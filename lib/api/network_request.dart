import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:netflix_clone/exceptions/bad_request.dart';
import 'package:netflix_clone/exceptions/internal_server_error.dart';

enum HttpMethods { get, post, put, patch, delete }

class NetworkRequest {
  NetworkRequest(
    this.urlString, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    this.method = HttpMethods.get,
  })  : headers = headers ?? {},
        body = body ?? {};

  final String urlString;
  final Map<String, String> headers;
  final Map<String, dynamic> body;
  final HttpMethods method;

  Future<dynamic> sendRequest() async {
    var url = Uri.parse(urlString);
    try {
      http.Response response;
      switch (method) {
        case HttpMethods.post:
          response = await http.post(url, body: body, headers: headers);
          break;
        case HttpMethods.put:
          response = await http.put(url, body: body, headers: headers);
          break;
        case HttpMethods.patch:
          response = await http.patch(url, body: body, headers: headers);
          break;
        case HttpMethods.delete:
          response = await http.delete(url, headers: headers);
          break;
        default:
          String queryString;
          if (body.isNotEmpty) {
            queryString = Uri(queryParameters: body).query;
            url = Uri.parse('$urlString?$queryString');
          }
          response = await http.get(url, headers: headers);
          break;
      }
      if (response.statusCode >= 400 && response.statusCode < 500) {
        final data = json.decode(response.body);
        throw BadRequest(data);
      } else if (response.statusCode >= 500) {
        throw const InternalServerError();
      } else {
        final data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }
}
