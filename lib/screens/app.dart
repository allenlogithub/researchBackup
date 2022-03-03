import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:web3dart1/w3d/wallet.dart';
import 'package:web3dart1/network/nft/getNftList.dart';
import 'package:web3dart1/network/httpCli.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Your Balance:',
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: Wallet().getBalance2(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.toString());
                } else {
                  return const Text('No data');
                }
              }),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Your NFTs:',
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: NFTApi(HttpCli()).getNFTAssets(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  NFTAssets? data = snapshot.data as NFTAssets?;
                  return Text(data!.assets.toString());
                } else {
                  return const Text('No data');
                }
              })
        ],
      ),
    );
  }
}
