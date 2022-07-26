// This file was generated by purescript-docs-search
window.DocsSearchTypeIndex["1267484798"] = [{"values":[{"sourceSpan":{"start":[119,1],"name":"src/Transaction.purs","end":[120,78]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"attachPlutusScript","moduleName":"Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Types","Scripts"],"PlutusScript"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Cardano","Types","Transaction"],"Transaction"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Effect"],"Effect"]},{"tag":"ParensInType","contents":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Data","Either"],"Either"]},{"tag":"TypeConstructor","contents":[["Transaction"],"ModifyTxError"]}]},{"tag":"TypeConstructor","contents":[["Cardano","Types","Transaction"],"Transaction"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":"Attach a `PlutusScript` to a transaction by modifying its existing witness\nset\n\nFails if either the script or updated witness set cannot be converted\nduring (de-)serialization\n"}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[103,1],"name":"src/Transaction.purs","end":[104,74]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"attachRedeemer","moduleName":"Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Cardano","Types","Transaction"],"Redeemer"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Cardano","Types","Transaction"],"Transaction"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Effect"],"Effect"]},{"tag":"ParensInType","contents":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Data","Either"],"Either"]},{"tag":"TypeConstructor","contents":[["Transaction"],"ModifyTxError"]}]},{"tag":"TypeConstructor","contents":[["Cardano","Types","Transaction"],"Transaction"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":"Attach a `Redeemer` to a transaction by modifying its existing witness set.\nNote that this is the `Types.Transaction` representation of a redeemer and\nnot a wrapped `PlutusData`.\nFails if either the redeemer or updated witness set cannot be converted\nduring (de-)serialization\n"}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[80,1],"name":"src/Transaction.purs","end":[80,81]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"attachDatum","moduleName":"Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Types","Datum"],"Datum"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Cardano","Types","Transaction"],"Transaction"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Effect"],"Effect"]},{"tag":"ParensInType","contents":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Data","Either"],"Either"]},{"tag":"TypeConstructor","contents":[["Transaction"],"ModifyTxError"]}]},{"tag":"TypeConstructor","contents":[["Cardano","Types","Transaction"],"Transaction"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":"Attach a `Datum` to a transaction by modifying its existing witness set.\nFails if either the datum or updated witness set cannot be converted during\n(de-)serialization\n"}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[855,1],"name":"src/Deserialization/Transaction.purs","end":[858,45]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"_unpackWithdrawals","moduleName":"Deserialization.Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["FfiHelpers"],"ContainerHelper"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"Withdrawals"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Array"]},{"tag":"ParensInType","contents":{"tag":"BinaryNoParensType","contents":[{"tag":"TypeOp","contents":[["Data","Tuple","Nested"],"/\\"]},{"tag":"TypeConstructor","contents":[["Serialization","Address"],"RewardAddress"]},{"tag":"TypeConstructor","contents":[["Types","BigNum"],"BigNum"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":null}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[870,1],"name":"src/Deserialization/Transaction.purs","end":[871,75]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"_unpackMintAssets","moduleName":"Deserialization.Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["FfiHelpers"],"ContainerHelper"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"MintAssets"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Array"]},{"tag":"ParensInType","contents":{"tag":"BinaryNoParensType","contents":[{"tag":"TypeOp","contents":[["Data","Tuple","Nested"],"/\\"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"AssetName"]},{"tag":"TypeConstructor","contents":[["Types","Int"],"Int"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":null}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[867,1],"name":"src/Deserialization/Transaction.purs","end":[868,73]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"_unpackMint","moduleName":"Deserialization.Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["FfiHelpers"],"ContainerHelper"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"Mint"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Array"]},{"tag":"ParensInType","contents":{"tag":"BinaryNoParensType","contents":[{"tag":"TypeOp","contents":[["Data","Tuple","Nested"],"/\\"]},{"tag":"TypeConstructor","contents":[["Serialization","Hash"],"ScriptHash"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"MintAssets"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":null}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[768,1],"name":"src/Deserialization/Transaction.purs","end":[771,52]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"_unpackMetadatums","moduleName":"Deserialization.Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["FfiHelpers"],"ContainerHelper"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"GeneralTransactionMetadata"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Array"]},{"tag":"ParensInType","contents":{"tag":"BinaryNoParensType","contents":[{"tag":"TypeOp","contents":[["Data","Tuple","Nested"],"/\\"]},{"tag":"TypeConstructor","contents":[["Types","BigNum"],"BigNum"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"TransactionMetadatum"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":null}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[721,1],"name":"src/Deserialization/Transaction.purs","end":[724,66]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"_unpackMetadataMap","moduleName":"Deserialization.Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["FfiHelpers"],"ContainerHelper"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"MetadataMap"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Array"]},{"tag":"ParensInType","contents":{"tag":"BinaryNoParensType","contents":[{"tag":"TypeOp","contents":[["Data","Tuple","Nested"],"/\\"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"TransactionMetadatum"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"TransactionMetadatum"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":null}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[716,1],"name":"src/Deserialization/Transaction.purs","end":[717,78]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"_unpackCostModels","moduleName":"Deserialization.Transaction","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["FfiHelpers"],"ContainerHelper"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"Costmdls"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Array"]},{"tag":"ParensInType","contents":{"tag":"BinaryNoParensType","contents":[{"tag":"TypeOp","contents":[["Data","Tuple","Nested"],"/\\"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"Language"]},{"tag":"TypeConstructor","contents":[["Serialization","Types"],"CostModel"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":null}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[481,1],"name":"src/BalanceTx/BalanceTx.purs","end":[484,57]},"score":0,"packageInfo":{"values":[],"tag":"LocalPackage"},"name":"balanceTxWithAddress","moduleName":"BalanceTx","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Serialization","Address"],"Address"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Types","ScriptLookups"],"UnattachedUnbalancedTx"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["QueryM"],"QueryM"]},{"tag":"ParensInType","contents":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Data","Either"],"Either"]},{"tag":"TypeConstructor","contents":[["BalanceTx"],"BalanceTxError"]}]},{"tag":"TypeConstructor","contents":[["BalanceTx"],"FinalizedTransaction"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":"Like `balanceTx`, but allows to provide an address that is treated like\nuser's own (while `balanceTx` gets it from the wallet).\n"}],"tag":"SearchResult"},{"values":[{"sourceSpan":{"start":[157,1],"name":".spago/affjax/v12.0.0/src/Affjax.purs","end":[157,68]},"score":0,"packageInfo":{"values":["affjax"],"tag":"Package"},"name":"patch_","moduleName":"Affjax","info":{"values":[{"type":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Affjax"],"URL"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Prim"],"Function"]},{"tag":"TypeConstructor","contents":[["Affjax","RequestBody"],"RequestBody"]}]},{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Effect","Aff"],"Aff"]},{"tag":"ParensInType","contents":{"tag":"TypeApp","contents":[{"tag":"TypeApp","contents":[{"tag":"TypeConstructor","contents":[["Data","Either"],"Either"]},{"tag":"TypeConstructor","contents":[["Affjax"],"Error"]}]},{"tag":"TypeConstructor","contents":[["Data","Unit"],"Unit"]}]}}]}]}]}}],"tag":"ValueResult"},"hashAnchor":"v","comments":"Makes a `PATCH` request to the specified URL with the option to send data\nand ignores the response body.\n"}],"tag":"SearchResult"}]