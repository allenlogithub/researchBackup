import 'package:web3dart1/network/httpCli.dart';

class NFTApi {
  final HttpCli _httpCli;

  NFTApi(this._httpCli);

  Future<NFTAssets> getNFTAssets() async {
    try {
      final res = await _httpCli.get(
          'testnets-api.opensea.io',
          '/api/v1/assets',
          {'owner': '0xfd6d1b7fb584edce7edb7be15f3c566c010aa11d'});
      return NFTAssets.fromMap(res);
    } catch (e) {
      throw e;
    }
  }
}

class NFTAssets {
  dynamic next;
  dynamic previous;
  List<dynamic>? assets;

  NFTAssets({
    this.next,
    this.previous,
    this.assets,
  });

  factory NFTAssets.fromMap(Map<String, dynamic> json) => NFTAssets(
        next: json['next'] ?? '',
        previous: json['previous'] ?? '',
        assets: json['assets'] ?? '',
      );
}
