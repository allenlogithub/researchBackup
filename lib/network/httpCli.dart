import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web3dart1/network/exceptions/exceptions.dart';

class HttpCli {
  final JsonDecoder _jsonDecoder = const JsonDecoder();

  Future<dynamic> get(String uri, String path, Map<String, dynamic> params) {
    return http.get(Uri.https(uri, path, params)).then(_createResponse);
  }

  dynamic _createResponse(http.Response response) {
    final String res = response.body;
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw NetworkException(
          message: 'Error fetching data from server', statusCode: statusCode);
    }

    return _jsonDecoder.convert(res);
  }
}
