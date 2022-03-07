import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowWalletAddress extends StatefulWidget {
  final String walletAddress;

  const ShowWalletAddress({Key? key, required this.walletAddress})
      : super(key: key);

  @override
  _ShowWalletAddressState createState() => _ShowWalletAddressState();
}

class _ShowWalletAddressState extends State<ShowWalletAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your Wallet Address is:',
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                widget.walletAddress,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ],
          )),
    );
  }
}
