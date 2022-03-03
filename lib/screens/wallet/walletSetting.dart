import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'package:web3dart1/config/config.dart';
import 'package:web3dart1/w3d/wallet.dart';
import 'package:web3dart1/screens/main.dart';

class WalletSetting extends StatefulWidget {
  const WalletSetting({Key? key}) : super(key: key);

  @override
  _WalletSettingState createState() => _WalletSettingState();
}

class _WalletSettingState extends State<WalletSetting> {
  final TextEditingController _walletPrimaryKeyController =
      TextEditingController();

  _setWalletPrimaryKey() async {
    appCfg['walletPK'] = _walletPrimaryKeyController.text;
    initWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Private Key?',
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
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
          ],
        ),
      ),
    );
  }
}
