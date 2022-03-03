import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:web3dart1/network/nft/getNftList.dart';
import 'package:web3dart1/network/httpCli.dart';

class OwnedNFT extends StatefulWidget {
  const OwnedNFT({Key? key}) : super(key: key);

  @override
  _OwnedNFTState createState() => _OwnedNFTState();
}

class _OwnedNFTState extends State<OwnedNFT> {
  late Future<NFTAssets> futureOwnedNFTResponse;

  @override
  void initState() {
    super.initState();
    futureOwnedNFTResponse = NFTApi(HttpCli()).getNFTAssets();
  }

  Future<void> _refresh() async {
    setState(() {
      print("refresh NFT Assets");
      futureOwnedNFTResponse = NFTApi(HttpCli()).getNFTAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<NFTAssets>(
            future: futureOwnedNFTResponse,
            builder: (context, snapshot) {
              List<dynamic> nfts = snapshot.data?.assets ?? [];
              if (nfts.isEmpty) {
                return Column();
              }
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                    itemCount: nfts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final nft = nfts[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Name:\n' + nft['asset_contract']['name'] + '\n',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Asset Address:\n' +
                                nft['asset_contract']['address'] +
                                '\n',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Created At:\n' +
                                nft['asset_contract']['created_date'] +
                                '\n',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Token Id:\n' + nft['token_id'] + '\n',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            color: Colors.white,
                          ),
                        ],
                      );
                    }),
              );
            }));
  }
}
