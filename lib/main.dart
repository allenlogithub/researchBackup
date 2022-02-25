import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:web3dart1/widgets/wallet.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        return GetMaterialApp(
          title: 'Hello Flutter',
          theme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: const Wallet(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
