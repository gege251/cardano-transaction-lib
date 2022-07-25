/* global BROWSER_RUNTIME */

exports._enableNami = () => window.cardano.nami.enable();

exports._enableGero = () => window.cardano.gerowallet.enable();

exports._enableEternl = () => window.cardano.eternl.enable();

const isWalletAvailable = walletName => () =>
  typeof window.cardano != "undefined" &&
  typeof window.cardano[walletName] != "undefined" &&
  typeof window.cardano[walletName].enable == "function";

exports._isNamiAvailable = isWalletAvailable("nami");

exports._isGeroAvailable = isWalletAvailable("gerowallet");

exports._isEternlAvailable = isWalletAvailable("eternl");
