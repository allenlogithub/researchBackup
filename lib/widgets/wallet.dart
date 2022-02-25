import 'package:flutter/material.dart';
import 'package:web3dart1/w3d/credentials.dart';

import 'package:web3dart1/config/config.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final TextEditingController _walletController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _walletController.text = appCfg['walletPK'];
  }

  void _sendWallet() {
    cred(_walletController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          TextField(
            controller: _walletController,
          ),
          IconButton(
              onPressed: _sendWallet, icon: const Icon(Icons.crop_square_sharp))
        ],
      ),
    );
  }
}
