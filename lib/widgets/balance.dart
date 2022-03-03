import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:web3dart1/w3d/wallet.dart';

class Balance extends StatefulWidget {
  const Balance({Key? key}) : super(key: key);

  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  late Future<dynamic> futureBalanceResponse;

  @override
  void initState() {
    super.initState();
    futureBalanceResponse = Wallet().getBalance2();
  }

  Future<void> _refresh() async {
    setState(() {
      print("refresh balance");
      futureBalanceResponse = Wallet().getBalance2();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            'Your Balance:',
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: futureBalanceResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.toString(),
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  );
                } else {
                  return const Text('No data');
                }
              }),
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
