import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'package:web3dart1/config/config.dart';

final String rpcUrl = appCfg['rpcUrl'];

late Web3Client rpcCli;

void initWallet() async {
  rpcCli = Web3Client(rpcUrl, Client());
}

class Wallet {
  final String privateKey = appCfg['walletPK'];

  EthereumAddress getWalledAddress() =>
      EthPrivateKey.fromHex(privateKey).address;

  Future getBalance2() => rpcCli.getBalance(getWalledAddress());
}
