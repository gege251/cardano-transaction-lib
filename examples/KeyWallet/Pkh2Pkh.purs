-- | This module demonstrates how the `Contract` interface can be used to build,
-- | balance, and submit a transaction. It creates a simple transaction that gets
-- | UTxOs from the user's wallet and sends the selected amount to the specified
-- | address
module Examples.KeyWallet.Pkh2Pkh (main) where

import Contract.Prelude

import Contract.Monad (liftedE, liftedM)
import Contract.Log (logInfo')
import Contract.ScriptLookups as Lookups
import Contract.Transaction
  ( awaitTxConfirmed
  , balanceAndSignTx
  , submit
  )
import Contract.TxConstraints as Constraints
import Contract.Value (lovelaceValueOf) as Value
import Examples.KeyWallet.Internal.Pkh2PkhContract (runKeyWalletContract_)

main :: Effect Unit
main = runKeyWalletContract_ \pkh lovelace unlock -> do
  logInfo' "Running Examples.KeyWallet.Pkh2Pkh"

  let
    constraints :: Constraints.TxConstraints Void Void
    constraints = Constraints.mustPayToPubKey pkh $
      Value.lovelaceValueOf lovelace

    lookups :: Lookups.ScriptLookups Void
    lookups = mempty

  ubTx <- liftedE $ Lookups.mkUnbalancedTx lookups constraints
  bsTx <-
    liftedM "Failed to balance/sign tx" $ balanceAndSignTx ubTx
  txId <- submit bsTx
  logInfo' $ "Tx ID: " <> show txId
  liftEffect unlock
  awaitTxConfirmed txId
  logInfo' $ "Tx submitted successfully!"
