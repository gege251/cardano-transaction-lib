module PreBalanceTx where

import Prelude
import Data.Array as Array
import Data.BigInt (BigInt)
import Data.Either (Either(..), hush, note)
import Data.List ((:), List(..))
import Data.List as List
import Data.Map as Map
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (over, unwrap)
import Data.Tuple.Nested ((/\), type (/\))
-- import Undefined (undefined)

import Ada (lovelaceValueOf)
import Types.Transaction as Transaction
import Value (emptyValue, filterNonAda, flattenValue, geq, isAdaOnly, isNonNeg, isZero, minus)

-- This module replicates functionality from
-- https://github.com/mlabs-haskell/mlabs-pab/blob/master/src/MLabsPAB/PreBalance.hs

-- | Pick a collateral from the utxo map and add it to the unbalanced transaction
-- | (suboptimally we just pick a random utxo from the tx inputs)
addTxCollaterals
  :: Transaction.Utxo
  -> Transaction.TxBody
  -> Either String Transaction.TxBody
addTxCollaterals utxos txBody = do
  let txIns :: Array Transaction.TransactionInput
      txIns =
        Array.mapMaybe (hush <<< toEitherTransactionInput)
          <<< Map.toUnfoldable
          <<< filterAdaOnly $ utxos
  txIn :: Transaction.TransactionInput <- findPubKeyTxIn txIns
  pure $
    over Transaction.TxBody _{ collateral = Just (Array.singleton txIn) } txBody
  where
    filterAdaOnly :: Transaction.Utxo -> Transaction.Utxo
    filterAdaOnly = Map.filter (isAdaOnly <<< getAmount)

    -- FIX ME: Plutus has Maybe TxInType e.g. Just ConsumePublicKeyAddress)
    -- for now, we take the head. The Haskell logic is pasted below:
    -- findPubKeyTxIn = \case
    --   x@(TxIn _ (Just ConsumePublicKeyAddress)) : _ -> Right x
    --   x@(TxIn _ Nothing) : _ -> Right x
    --   _ : xs -> findPubKeyTxIn xs
    --   _ -> Left "There are no utxos to be used as collateral"
    findPubKeyTxIn
      :: Array Transaction.TransactionInput
      -> Either String Transaction.TransactionInput
    findPubKeyTxIn =
      note "addTxCollaterals: There are no utxos to be used as collateral"
        <<< Array.head

-- Converting an Ogmios transaction output to a transaction input type
-- FIX ME: may need to revisit for credential granularity.
toEitherTransactionInput
  :: (Transaction.TransactionInput /\ Transaction.TransactionOutput)
  -> Either String Transaction.TransactionInput
toEitherTransactionInput (txOutRef /\ txOut) =
  case txOutPaymentCredentials txOut of
    Transaction.Credential _ ->
      pure txOutRef
    _ -> -- Currently unreachable:
      Left "toEitherTransactionInput: Cannot convert an output to \
        \TransactionInput"

addressPaymentCredentials :: Transaction.Address -> Transaction.Credential
addressPaymentCredentials = _.payment <<< unwrap <<< _."AddrType" <<< unwrap

-- FIX ME: do we need granularity for staking credential? Is this equivalent
-- to getting pubkeyhash?
txOutPaymentCredentials
  :: Transaction.TransactionOutput
  -> Transaction.Credential
txOutPaymentCredentials = addressPaymentCredentials <<< _.address  <<< unwrap

-- -- FIX ME: This behaves differently to pubKeyTxIn because of TxInType, see
-- -- https://play.marlowe-finance.io/doc/haddock/plutus-ledger-api/html/src/Plutus.V1.Ledger.Tx.html#pubKeyTxIn
-- txOutRefToTransactionInput :: JsonWsp.TxOutRef -> Transaction.TransactionInput
-- txOutRefToTransactionInput { txId, index } =
--   Transaction.TransactionInput { transaction_id: txId, index }

-- | We need to balance non ada values, as the cardano-cli is unable to balance
-- | them (as of 2021/09/24)
balanceNonAdaOuts
  :: Transaction.Address -- FIX ME: (payment credential) address for change substitute for pkh.
  -> Transaction.Utxo
  -> Transaction.TxBody
  -> Either String Transaction.TxBody
balanceNonAdaOuts changeAddr utxos txBody =
  let unwrapTxBody = unwrap txBody

      -- FIX ME: Similar to Transaction.Address issue, need pkh.
      payCredentials :: Transaction.Credential
      payCredentials = addressPaymentCredentials changeAddr

      txOutputs :: Array Transaction.TransactionOutput
      txOutputs = unwrapTxBody.outputs

      inputValue :: Transaction.Value
      inputValue =
        Array.foldMap
          getAmount
          (Array.mapMaybe (flip Map.lookup utxos) <<< _.inputs $ unwrapTxBody)

      outputValue :: Transaction.Value
      outputValue = Array.foldMap getAmount txOutputs

      nonMintedOutputValue:: Transaction.Value
      nonMintedOutputValue =
        outputValue `minus` fromMaybe emptyValue unwrapTxBody.mint

      nonAdaChange :: Transaction.Value
      nonAdaChange =
        filterNonAda inputValue `minus` filterNonAda nonMintedOutputValue

      outputs :: Array Transaction.TransactionOutput
      outputs =
        Array.fromFoldable $ -- FIX ME: Only use arrays?
          case List.partition
            ((==) payCredentials <<< txOutPaymentCredentials)
            <<< Array.toUnfoldable $ txOutputs of
              { no: txOuts, yes: Nil } ->
                Transaction.TransactionOutput
                  { address: changeAddr,
                    amount: nonAdaChange,
                    data_hash: Nothing
                  } : txOuts
              { no: txOuts'
              , yes: Transaction.TransactionOutput txOut@{ amount: v } : txOuts
              } ->
                Transaction.TransactionOutput
                  txOut { amount = v <> nonAdaChange } : txOuts <> txOuts'
   in if isNonNeg nonAdaChange
       then pure $
        if isZero nonAdaChange
         then txBody
         else Transaction.TxBody $ unwrapTxBody {outputs = outputs}
       else Left "balanceNonAdaOuts: Not enough inputs to balance tokens."

getAmount :: Transaction.TransactionOutput -> Transaction.Value
getAmount = _.amount <<< unwrap

-- balanceNonAdaOuts :: PubKeyHash -> Map TxOutRef TxOut -> Tx -> Either Text Tx
-- balanceNonAdaOuts addr utxos tx =
--   let changeAddr = Ledger.pubKeyHashAddress ownPkh
--       txInRefs = map Tx.txInRef $ Set.toList $ txInputs tx
--       inputValue = mconcat $ map Tx.txOutValue $ mapMaybe (`Map.lookup` utxos) txInRefs
--       outputValue = mconcat $ map Tx.txOutValue $ txOutputs tx
--       nonMintedOutputValue = outputValue `minus` txMint tx
--       nonAdaChange = filterNonAda inputValue `minus` filterNonAda nonMintedOutputValue
--       outputs =
--         case partition ((==) changeAddr . Tx.txOutAddress) $ txOutputs tx of
--           ([], txOuts) ->
--             TxOut
--               { txOutAddress = changeAddr
--               , txOutValue = nonAdaChange
--               , txOutDatumHash = Nothing
--               } :
--             txOuts
--           (txOut@TxOut {txOutValue = v} : txOuts, txOuts') ->
--             txOut {txOutValue = v <> nonAdaChange} : (txOuts <> txOuts')
--    in if isValueNat nonAdaChange
--         then Right $ if Value.isZero nonAdaChange then tx else tx {txOutputs = outputs}
--         else Left "Not enough inputs to balance tokens."

balanceTxIns
  :: Transaction.Utxo
  -> BigInt
  -> Transaction.TxBody
  -> Either String Transaction.TxBody
balanceTxIns utxos fees txBody = do
  let unwrapTxBody = unwrap txBody

      txOuts :: Array Transaction.TransactionOutput
      txOuts = unwrapTxBody.outputs -- FIX ME: txOuts txOutputs rename elsewhere?

      nonMintedValue :: Transaction.Value
      nonMintedValue =
        Array.foldMap getAmount txOuts
        `minus` fromMaybe emptyValue unwrapTxBody.mint

      minSpending :: Transaction.Value
      minSpending = lovelaceValueOf fees <> nonMintedValue

  txIns :: Array Transaction.TransactionInput
    <- collectTxIns unwrapTxBody.inputs utxos minSpending
  pure $ Transaction.TxBody $
    unwrapTxBody { inputs = txIns <> unwrapTxBody.inputs }

-- balanceTxIns :: Transaction.Utxo -> Integer -> Tx -> Either Text Tx
-- balanceTxIns utxos fees tx = do
--   let txOuts = Tx.txOutputs tx
--       nonMintedValue = mconcat (map Tx.txOutValue txOuts) `minus` txMint tx
--       minSpending =
--         mconcat
--           [ Ada.lovelaceValueOf fees
--           , nonMintedValue
--           ]
--   txIns <- collectTxIns (txInputs tx) utxos minSpending
--   pure $ tx {txInputs = txIns <> txInputs tx}

collectTxIns
  :: Array Transaction.TransactionInput
  -> Transaction.Utxo
  -> Transaction.Value
  -> Either String (Array Transaction.TransactionInput)
collectTxIns originalTxIns utxos value =
  if isSufficient updatedInputs
   then pure updatedInputs
   else
    Left $
      "collectTxIns: Insufficient tx inputs, needed: "
      <> show (flattenValue value)
      <> ", got: "
      <> show (flattenValue $ txInsValue updatedInputs)
  where
    updatedInputs :: Array Transaction.TransactionInput
    updatedInputs =
      Array.foldl
        ( \acc txIn ->
            if isSufficient acc
             then acc
             else Array.insert txIn acc
        )
        originalTxIns
        -- FIX ME THIS TO ARRAY ONLY and previous usage, also refactor out mapMaybe fun.
        $ Array.mapMaybe (hush <<< toEitherTransactionInput) <<< Map.toUnfoldable $ utxos

    isSufficient :: Array Transaction.TransactionInput -> Boolean
    isSufficient txIns' =
      not (Array.null txIns') && txInsValue txIns' `geq` value

    -- FIX ME: refactor into a function.
    txInsValue :: Array Transaction.TransactionInput -> Transaction.Value
    txInsValue =
      Array.foldMap getAmount <<< Array.mapMaybe (flip Map.lookup utxos)

--   -- | Getting the necessary utxos to cover the fees for the transaction
-- collectTxIns :: Set TxIn -> Map TxOutRef TxOut -> Value -> Either Text (Set TxIn)
-- collectTxIns originalTxIns utxos value =
--   if isSufficient updatedInputs
--     then Right updatedInputs
--     else
--       Left $
--         Text.unlines
--           [ "Insufficient tx inputs, needed: "
--           , showText (Value.flattenValue value)
--           , "got:"
--           , showText (Value.flattenValue (txInsValue updatedInputs))
--           ]
--   where
--     updatedInputs =
--       foldl
--         ( \acc txIn ->
--             if isSufficient acc
--               then acc
--               else Set.insert txIn acc
--         )
--         originalTxIns
--         $ mapMaybe (rightToMaybe . txOutToTxIn) $ Map.toList utxos

--     isSufficient :: Set TxIn -> Bool
--     isSufficient txIns' =
--       not (Set.null txIns') && txInsValue txIns' `Value.geq` value

--     txInsValue :: Set TxIn -> Value
--     txInsValue txIns' =
--       mconcat $ map Tx.txOutValue $ mapMaybe ((`Map.lookup` utxos) . Tx.txInRef) $ Set.toList txIns'

-- -- | Add min lovelaces to each tx output
-- addLovelaces :: [(TxOut, Integer)] -> Tx -> Tx
-- addLovelaces minLovelaces tx =
--   let lovelacesAdded =
--         map
--           ( \txOut ->
--               let outValue = txOutValue txOut
--                   lovelaces = Ada.getLovelace $ Ada.fromValue outValue
--                   minUtxo = fromMaybe 0 $ lookup txOut minLovelaces
--                in txOut
--                     { txOutValue =
--                         outValue <> Ada.lovelaceValueOf (max 0 (minUtxo - lovelaces))
--                     }
--           )
--           $ txOutputs tx
--    in tx {txOutputs = lovelacesAdded}

-- -- | Add min lovelaces to each tx output
-- addLovelaces :: [(TxOut, Integer)] -> Tx -> Tx
-- addLovelaces minLovelaces tx =
--   let lovelacesAdded =
--         map
--           ( \txOut ->
--               let outValue = txOutValue txOut
--                   lovelaces = Ada.getLovelace $ Ada.fromValue outValue
--                   minUtxo = fromMaybe 0 $ lookup txOut minLovelaces
--                in txOut
--                     { txOutValue =
--                         outValue <> Ada.lovelaceValueOf (max 0 (minUtxo - lovelaces))
--                     }
--           )
--           $ txOutputs tx
--    in tx {txOutputs = lovelacesAdded}