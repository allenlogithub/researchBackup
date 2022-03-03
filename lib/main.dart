import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:web3dart1/screens/wallet/walletSetting.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Client',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const WalletSetting(),
      debugShowCheckedModeBanner: false,
    );
  }
}
