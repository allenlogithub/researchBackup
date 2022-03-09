import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowTxHash extends StatefulWidget {
  final String TxHash;
  const ShowTxHash({Key? key, required this.TxHash}) : super(key: key);

  @override
  _ShowTxHashState createState() => _ShowTxHashState();
}

class _ShowTxHashState extends State<ShowTxHash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your Tx Hash is:',
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                widget.TxHash,
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
