# CTL integration with Plutip

[Plutip](https://github.com/mlabs-haskell/plutip) is a tool to run private Cardano testnets. CTL provides integration with Plutip via a [`plutip-server` binary](https://github.com/mlabs-haskell/plutip/pull/79) that exposes an HTTP interface to control local Cardano clusters.

**Table of Contents**

- [Architecture](#architecture)
- [Testing contracts](#testing-contracts)
- [Limitations](#limitations)

## Architecture

CTL depends on a number of binaries in the `$PATH` to execute Plutip tests:

- `plutip-server` to launch a local `cardano-node` cluster
- [`ogmios`](https://ogmios.dev/)
- [`ogmios-datum-cache`](https://github.com/mlabs-haskell/ogmios-datum-cache)
- PostgreSQL: `initdb`, `createdb` and `psql` for `ogmios-datum-cache` storage
- `ctl-server`: a server-side part of CTL itself.

All of these are provided by CTL's `overlays.runtime` (and are provided in CTL's own `devShell`). You **must** use the `runtime` overlay or otherwise make the services available in your package set (e.g. by defining them within your own `overlays` when instantiating `nixpkgs`) as `purescriptProject.runPlutipTest` expects all of them.

The services are NOT run by `docker-compose` as is the case with `launchCtlRuntime`: they are started and stopped on each CTL `Contract` execution by CTL.

## Testing contracts

The main entry point to the testing interface is `Contract.Test.Plutip.runPlutipContract` function:

```purescript
runPlutipContract
  :: forall (distr :: Type) (wallets :: Type) (a :: Type)
   . UtxoDistribution distr wallets
  => PlutipConfig
  -> distr
  -> (wallets -> Contract () a)
  -> Aff a
```

`distr` is a specification of how many wallets and with how much funds should be created. It should either be a `unit` (for no wallets) or nested tuples containing `Array BigInt` - each element of the array specifies an UTxO amount in Lovelaces (0.000001 Ada).

The `wallets` argument is either a `Unit` or a tuple of `KeyWallet`s (with the same nesting level as in `distr`, which is guaranteed by `UtxoDistribution`).

`wallets` should be pattern-matched on, and its components should be passed to `withKeyWallet`:

An example `Contract` with two actors:

```purescript
let
  distribution :: Array BigInt /\ Array BigInt
  distribution =
    [ BigInt.fromInt 1_000_000_000
    , BigInt.fromInt 2_000_000_000
    ] /\
      [ BigInt.fromInt 2_000_000_000 ]
runPlutipContract config distribution \(alice /\ bob) -> do
  withKeyWallet alice do
    pure unit -- sign, balance, submit, etc.
  withKeyWallet bob do
    pure unit -- sign, balance, submit, etc.
```

In most cases at least two UTxOs per wallet are needed (one of which will be used as collateral, so it should exceed `5_000_000` Lovelace).

Note that during execution WebSocket connection errors may occur. However, payloads are re-sent after these errors, so you can ignore them. [These errors will be suppressed in the future.](https://github.com/Plutonomicon/cardano-transaction-lib/issues/670).

## Limitations

- Plutip does not currently provide staking keys. However, arbitrary staking keys can be used if the application does not depend on staking (because payment keys and stake keys don't have to be connected in any way). It's also possible to omit staking keys in many cases by using `mustPayToPubKey` instead of `mustPayToPubKeyAddress`.
