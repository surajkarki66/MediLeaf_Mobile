import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:medileaf/business_logic/exceptions/exception_handlers.dart';

class BaseClient {
  static const int timeOutDuration = 35;

  //GET
  Future<dynamic> get(String url, Map<String, String>? headers) async {
    try {
      Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
  }

  //POST
  Future<dynamic> post(String url, dynamic payload,
      {Map<String, String>? headers}) async {
    try {
      Response response = await http
          .post(
            Uri.parse(url),
            body: payload,
            headers: headers,
          )
          .timeout(const Duration(seconds: timeOutDuration));

      return _processResponse(response);
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
  }

  //DELETE
  //OTHERS

//----------------------ERROR STATUS CODES----------------------

  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200 || 201:
        return {"body": response.body, "headers": response.headers};
      case 400: //Bad request
        dynamic responseBody = jsonDecode(response.body);
        dynamic errorMessage;
        if (responseBody.containsKey('message')) {
          final errorMessages = (responseBody.values.toList());

          errorMessage = errorMessages[0];
        } else {
          final errors = responseBody.values.toList();
          errorMessage = errors[0];
        }
        throw BadRequestException(errorMessage[0]);
      case 401: //Unauthorized
        throw UnAuthorizedException(jsonDecode(response.body)['details']);
      case 403: //Forbidden
        throw UnAuthorizedException(jsonDecode(response.body)['details']);
      case 404: //Resource Not Found
        throw NotFoundException(jsonDecode(response.body)['message'][0]);
      case 500: //Internal Server Error
      default:
        throw FetchDataException(
            'Something went wrong! ${response.statusCode}');
    }
  }
}
