import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
// import 'package:web3dart/web3dart.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:web3dart1/config/config.dart';
import 'package:web3dart1/w3d/wallet.dart';
import 'package:web3dart1/screens/main.dart';
import 'package:web3dart1/launcher/wallet.dart';
import 'package:web3dart1/screens/wallet/showWalletAddress.dart';
import 'package:web3dart1/screens/wallet/showTxHash.dart';
import 'package:web3dart1/launcher/txRequest.dart';

enum NetworkType {
  ethereum,
  algorand,
}

enum TransactionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  transferring,
  success,
  failed,
}

class WalletSetting extends StatefulWidget {
  const WalletSetting({Key? key}) : super(key: key);

  @override
  _WalletSettingState createState() => _WalletSettingState();
}

class _WalletSettingState extends State<WalletSetting> {
  final TextEditingController _walletPrimaryKeyController =
      TextEditingController();

  String txId = '';
  String _displayUri = '';

  static const _networks = ['Ethereum (Ropsten)', 'Algorand (Testnet)'];
  NetworkType? _network = NetworkType.ethereum;
  TransactionState _state = TransactionState.disconnected;
  TransactionTester? _transactionTester = EthereumTransactionTester();
  // String walletAddress = '';
  late SessionStatus session;
  late String sTx;

  String TxHash = 'no TxHash';

  _setWalletPrimaryKey() async {
    appCfg['walletPK'] = _walletPrimaryKeyController.text;
    initWallet();
  }

  @override
  Widget build(BuildContext context) {
    return WalletConnectLifecycle(
      connector: _transactionTester!.connector,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Private Key?',
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _walletPrimaryKeyController,
              ),
              IconButton(
                  onPressed: () async {
                    await _setWalletPrimaryKey();
                    Get.to(const Main());
                  },
                  icon: const Icon(Icons.vpn_key)),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Wallet Connection',
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await launchWallet().then((value) {
                      // walletAddress = value;
                      session = value;
                    });
                    Get.to(ShowWalletAddress(
                      // walletAddress: walletAddress,
                      walletAddress: session.accounts[0].toString(),
                    ));
                  },
                  child: const Text('Connect')),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Tx',
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                // onPressed: _transactionStateToAction(context, state: _state),
                onPressed: _transactionStateToAction(context,
                    state: _state, txHash: TxHash),
                child: Text(
                  _transactionStateToString(state: _state),
                ),
              ),
              Text(
                'TxHash: ' + TxHash,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _transactionTester?.disconnect();
                },
                child: const Text(
                  'Close',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _transactionStateToString({required TransactionState state}) {
    switch (state) {
      case TransactionState.disconnected:
        return 'Connect!';
      case TransactionState.connecting:
        return 'Connecting';
      case TransactionState.connected:
        return 'Session connected, preparing transaction...';
      case TransactionState.connectionFailed:
        return 'Connection failed';
      case TransactionState.transferring:
        return 'Transaction in progress...';
      case TransactionState.success:
        return 'Transaction successful';
      case TransactionState.failed:
        return 'Transaction failed';
    }
  }

  VoidCallback? _transactionStateToAction(BuildContext context,
      // {required TransactionState state}) {
      {required TransactionState state,
      required String txHash}) {
    switch (state) {
      // Progress, action disabled
      case TransactionState.connecting:
      case TransactionState.transferring:
      case TransactionState.connected:
        return null;

      // Initiate the connection
      case TransactionState.disconnected:
      case TransactionState.connectionFailed:
        return () async {
          setState(() => _state = TransactionState.connecting);
          final session = await _transactionTester?.connect(
              onDisplayUri: (uri) async => {
                    setState(() => {
                          _displayUri = uri,
                          print(uri),
                        }),
                    if (await canLaunch(uri))
                      {await launch(uri)}
                    else
                      {throw 'Could not launch $uri'}
                  });
          // print('session:');
          // print(session);
          // print(session!.chainId);
          // print(session.rpcUrl);
          // print('session: end');
          if (session == null) {
            print('Unable to connect');
            setState(() => _state = TransactionState.failed);
            return;
          }

          print('session:');
          print(session);
          print(session.chainId);
          print(session.rpcUrl);
          print('session: end');

          setState(() => _state = TransactionState.connected);
          Future.delayed(const Duration(seconds: 1), () async {
            // Initiate the transaction
            setState(() => _state = TransactionState.transferring);
            try {
              String temp = await _transactionTester!.signTransaction(session);
              // setState(() => _state = TransactionState.success);
              setState(() {
                _state = TransactionState.success;
                txHash = temp;
                print('++++++++++++++++');
                print(_state);
                print(txHash);
                print('++++++++++++++++');
              });
            } catch (e) {
              print('Transaction error: $e');
              setState(() => _state = TransactionState.failed);
              print('++++++++++++++++');
              print(_state);
              print(txHash);
              print('++++++++++++++++');
            }
          });
        };

      // Finished
      case TransactionState.success:
        return null;
      case TransactionState.failed:
        return null;
    }
  }
}

class WalletConnectLifecycle extends StatefulWidget {
  final WalletConnect connector;
  final Widget child;

  const WalletConnectLifecycle({
    Key? key,
    required this.connector,
    required this.child,
  }) : super(key: key);

  @override
  State<WalletConnectLifecycle> createState() => _WalletConnectLifecycleState();
}

class _WalletConnectLifecycleState extends State<WalletConnectLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState: ${state.toString()}.');
    final connector = widget.connector;
    if (state == AppLifecycleState.resumed && mounted) {
      if (connector.connected && !connector.bridgeConnected) {
        print('Attempt to recover');
        connector.reconnect();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
