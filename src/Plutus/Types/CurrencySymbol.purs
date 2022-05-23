module Plutus.Types.CurrencySymbol
  ( CurrencySymbol
  , adaSymbol
  , currencyMPSHash
  , getCurrencySymbol
  , mkCurrencySymbol
  , mpsSymbol
  , scriptHashAsCurrencySymbol
  ) where

import Prelude

import Aeson
  ( class DecodeAeson
  , class EncodeAeson
  , caseAesonObject
  , decodeAeson
  , encodeAeson'
  , getField
  , JsonDecodeError(TypeMismatch)
  )
import Data.Either (Either(Left))
import Data.Maybe (Maybe)
import Types.FromData (class FromData)
import Serialization.Hash
  ( ScriptHash
  , scriptHashAsBytes
  , scriptHashFromBytes
  , scriptHashToBytes
  )
import Types.ToData (class ToData)
import Types.ByteArray (ByteArray)
import Data.Newtype (unwrap, wrap)
import Types.Scripts (MintingPolicyHash(MintingPolicyHash))

newtype CurrencySymbol = CurrencySymbol ByteArray

derive newtype instance Eq CurrencySymbol
derive newtype instance Ord CurrencySymbol
derive newtype instance FromData CurrencySymbol
derive newtype instance ToData CurrencySymbol

instance DecodeAeson CurrencySymbol where
  decodeAeson = caseAesonObject
    (Left $ TypeMismatch "Expected object")
    (flip getField "unCurrencySymbol" >=> decodeAeson >>> map CurrencySymbol)

instance EncodeAeson CurrencySymbol where
  encodeAeson' (CurrencySymbol mph) = do
    mph' <- encodeAeson' mph
    encodeAeson'
      { "unCurrencySymbol": mph' }

instance Show CurrencySymbol where
  show (CurrencySymbol cs) = "(CurrencySymbol" <> show cs <> ")"

adaSymbol :: CurrencySymbol
adaSymbol = CurrencySymbol mempty

scriptHashAsCurrencySymbol :: ScriptHash -> CurrencySymbol
scriptHashAsCurrencySymbol = CurrencySymbol <<< unwrap <<< scriptHashAsBytes

-- | The minting policy hash of a currency symbol.
currencyMPSHash :: CurrencySymbol -> Maybe MintingPolicyHash
currencyMPSHash = map MintingPolicyHash <<< currencyScriptHash

-- | The currency symbol of a monetary policy hash.
mpsSymbol :: MintingPolicyHash -> Maybe CurrencySymbol
mpsSymbol (MintingPolicyHash h) = mkCurrencySymbol <<< unwrap $
  scriptHashToBytes h

getCurrencySymbol :: CurrencySymbol -> ByteArray
getCurrencySymbol (CurrencySymbol curSymbol) = curSymbol

mkCurrencySymbol :: ByteArray -> Maybe CurrencySymbol
mkCurrencySymbol byteArr
  | byteArr == mempty =
      pure adaSymbol
  | otherwise =
      scriptHashFromBytes (wrap byteArr) $> CurrencySymbol byteArr

--------------------------------------------------------------------------------
-- Internal
--------------------------------------------------------------------------------

currencyScriptHash :: CurrencySymbol -> Maybe ScriptHash
currencyScriptHash = scriptHashFromBytes <<< wrap <<< getCurrencySymbol
