module Wallet.Key
  ( KeyWallet(KeyWallet)
  , PrivatePaymentKey(PrivatePaymentKey)
  , PrivateStakeKey(PrivateStakeKey)
  , privateKeysToKeyWallet
  ) where

import Prelude

import Cardano.Types.Transaction
  ( Transaction(Transaction)
  , Utxos
  , _vkeys
  , TransactionOutput(TransactionOutput)
  )
import Cardano.Types.TransactionUnspentOutput
  ( TransactionUnspentOutput(TransactionUnspentOutput)
  )
import Cardano.Types.Value (NonAdaAsset(NonAdaAsset), Value(Value), mkCoin)
import Contract.Prelude (class Newtype)
import Data.FoldableWithIndex (foldMapWithIndex)
import Data.Lens (set)
import Data.List (all)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Newtype (unwrap)
import Data.Ord.Min (Min(Min))
import Deserialization.WitnessSet as Deserialization.WitnessSet
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Serialization (publicKeyFromPrivateKey, publicKeyHash)
import Serialization as Serialization
import Serialization.Address
  ( Address
  , NetworkId
  , baseAddress
  , baseAddressToAddress
  , enterpriseAddress
  , enterpriseAddressToAddress
  , keyHashCredential
  )
import Serialization.Types (PrivateKey)

-------------------------------------------------------------------------------
-- Key backend
-------------------------------------------------------------------------------
newtype KeyWallet = KeyWallet
  { address :: NetworkId -> Aff Address
  , selectCollateral :: Utxos -> Maybe TransactionUnspentOutput
  , signTx :: Transaction -> Aff Transaction
  }

derive instance Newtype KeyWallet _

newtype PrivatePaymentKey = PrivatePaymentKey PrivateKey

derive instance Newtype PrivatePaymentKey _

newtype PrivateStakeKey = PrivateStakeKey PrivateKey

derive instance Newtype PrivateStakeKey _

privateKeysToKeyWallet
  :: PrivatePaymentKey -> Maybe PrivateStakeKey -> KeyWallet
privateKeysToKeyWallet payKey mbStakeKey = KeyWallet
  { address
  , selectCollateral
  , signTx
  }
  where
  address :: NetworkId -> Aff Address
  address network = do
    pubPayKey <- liftEffect $ publicKeyFromPrivateKey (unwrap payKey)
    case mbStakeKey of
      Just stakeKey -> do
        pubStakeKey <- liftEffect $ publicKeyFromPrivateKey (unwrap stakeKey)
        pure $ baseAddressToAddress $
          baseAddress
            { network
            , paymentCred: keyHashCredential $ publicKeyHash $ pubPayKey
            , delegationCred: keyHashCredential $ publicKeyHash $ pubStakeKey
            }

      Nothing -> pure $ pubPayKey # publicKeyHash
        >>> keyHashCredential
        >>> { network, paymentCred: _ }
        >>> enterpriseAddress
        >>> enterpriseAddressToAddress

  selectCollateral :: Utxos -> Maybe TransactionUnspentOutput
  selectCollateral utxos = unwrap <<< unwrap <$> flip
    foldMapWithIndex
    utxos
    \input output ->
      let
        txuo = AdaOut $ TransactionUnspentOutput { input, output }
        Value ada (NonAdaAsset naa) = _value txuo
        onlyAda = all (all ((==) zero)) naa
        bigAda = ada >= mkCoin 5_000_000
      in
        if onlyAda && bigAda then Just $ Min txuo
        else Nothing

  signTx :: Transaction -> Aff Transaction
  signTx (Transaction tx) = liftEffect do
    txBody <- Serialization.convertTxBody tx.body
    hash <- Serialization.hashTransaction txBody
    wit <- Deserialization.WitnessSet.convertVkeyWitness <$>
      Serialization.makeVkeywitness hash (unwrap payKey)
    let witnessSet' = set _vkeys (pure $ pure wit) mempty
    pure $ Transaction $ tx { witnessSet = witnessSet' <> tx.witnessSet }

_value :: AdaOut -> Value
_value
  (AdaOut (TransactionUnspentOutput { output: TransactionOutput { amount } })) =
  amount

-- A wrapper around a UTxO, ordered by ada value
newtype AdaOut = AdaOut TransactionUnspentOutput

derive instance Newtype AdaOut _

instance Eq AdaOut where
  eq a b
    | Value a' _ <- _value a
    , Value b' _ <- _value b = eq a' b'

instance Ord AdaOut where
  compare a b
    | Value a' _ <- _value a
    , Value b' _ <- _value b = compare a' b'
