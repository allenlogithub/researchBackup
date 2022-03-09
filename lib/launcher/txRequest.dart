import 'dart:typed_data';

import 'package:http/http.dart';
// import 'package:mobile_dapp/transaction_tester.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'package:web3dart1/config/config.dart';
import 'package:web3dart1/launcher/wallet.dart';

walletConnectSession() async {
  SessionStatus? session;

  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'WalletConnect',
      description: 'WalletConnect Developer App',
      url: 'https://walletconnect.org',
      icons: ['https://walletconnect.org/walletconnect-logo.png'],
    ),
  );

  // Subscribe to events
  connector.on(
      'connect', (session) => print('connect session: ' + session.toString()));
  connector.on('session_update',
      (payload) => print('session_update payload: ' + payload.toString()));
  connector.on('disconnect',
      (session) => print('disconnect session: ' + session.toString()));

  // Create a new session
  if (!connector.connected) {
    session = await connector.createSession(
        chainId: 4,
        onDisplayUri: (uri) => {
              print('uri: ' + uri.toString()),
            });
  }
}

abstract class TransactionTester {
  TransactionTester({required this.connector});

  final WalletConnect connector;

  Future<String> signTransaction(SessionStatus session);

  Future<String> signTransactions(SessionStatus session);

  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri});

  Future<void> disconnect();
}

class WalletConnectEthereumCredentials extends CustomTransactionSender {
  WalletConnectEthereumCredentials({required this.provider});

  final EthereumWalletConnectProvider provider;

  @override
  Future<EthereumAddress> extractAddress() {
    // TODO: implement extractAddress
    throw UnimplementedError();
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    print('sendTransaction ING');
    final hash = await provider.sendTransaction(
      from: transaction.from!.hex,
      to: transaction.to?.hex,
      data: transaction.data,
      gas: transaction.maxGas,
      gasPrice: transaction.gasPrice?.getInWei,
      value: transaction.value?.getInWei,
      nonce: transaction.nonce,
    );

    return hash;
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }
}

class EthereumTransactionTester extends TransactionTester {
  final Web3Client ethereum;
  final EthereumWalletConnectProvider provider;

  EthereumTransactionTester._internal({
    required WalletConnect connector,
    required this.ethereum,
    required this.provider,
  }) : super(connector: connector);

  factory EthereumTransactionTester() {
    final ethereum = Web3Client(appCfg['rpcUrl'], Client());

    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: ['https://walletconnect.org/walletconnect-logo.png'],
      ),
    );

    final provider = EthereumWalletConnectProvider(connector);

    return EthereumTransactionTester._internal(
      connector: connector,
      ethereum: ethereum,
      provider: provider,
    );
  }

  @override
  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri}) async {
    print('connect ING');
    return connector.connect(chainId: 4, onDisplayUri: onDisplayUri);
  }

  @override
  Future<void> disconnect() async {
    print('disconnect ING');
    await connector.killSession();
  }

  @override
  Future<String> signTransaction(SessionStatus session) async {
    print('signTransaction ING');
    final sender = EthereumAddress.fromHex(session.accounts[0]);
    final receiver =
        EthereumAddress.fromHex('0xFd6d1b7FB584edce7EDB7BE15f3c566c010AA11D');
    print('sender:');
    print(sender);
    print('receiver:');
    print(receiver);

    final transaction = Transaction(
      to: receiver,
      // to: sender,
      from: sender,
      gasPrice: EtherAmount.inWei(BigInt.from(230000000)),
      // gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 1000000,
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 10),
    );

    print('provider:');
    print(provider.chainId);
    print(provider.connector);
    final credentials = WalletConnectEthereumCredentials(provider: provider);
    print('credentials:');
    print(credentials);
    print(credentials.provider);
    print(credentials.provider.connector);

    // Sign the transaction
    final txBytes = await ethereum.sendTransaction(credentials, transaction);
    print('txBytes:');
    print(txBytes);

    // Kill the session
    connector.killSession();
    print('connector.killSession');

    return txBytes;
  }

  @override
  Future<String> signTransactions(SessionStatus session) {
    // TODO: implement signTransactions
    throw UnimplementedError();
  }
}
