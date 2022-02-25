import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'package:web3dart1/config/config.dart';

final String rpcUrl = appCfg['rpcUrl'];

void cred(String privateKey) async {
  final client = Web3Client(rpcUrl, Client());

  final credentials = EthPrivateKey.fromHex(privateKey);
  final address = credentials.address;

  print(address.hexEip55);
  print(await client.getBalance(address));
  await client.getBlockInformation().then((value) {
    print("value.baseFeePerGas:");
    print(value.baseFeePerGas);
  });

  await client.dispose();
}
