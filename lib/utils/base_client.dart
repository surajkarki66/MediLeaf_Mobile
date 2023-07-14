// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:http/http.dart';
import 'package:requests/requests.dart';

import 'package:medileaf/business_logic/exceptions/exception_handlers.dart';

class BaseClient {
  static const int timeOutDuration = 35;

  //GET
  Future<dynamic> get(String url, Map<String, String>? headers) async {
    try {
      Response response =
          await Requests.get(url, headers: headers, withCredentials: true)
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
      print(headers);
      Response response = await Requests.post(url,
              body: payload,
              withCredentials: true,
              headers: headers,
              bodyEncoding: RequestBodyEncoding.FormURLEncoded)
          .timeout(const Duration(seconds: timeOutDuration));
      print(response.body);
      return _processResponse(response);
    } catch (e) {
      print(e);
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
        dynamic responseBody = response.json();
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
        throw UnAuthorizedException(response.json()['details']);
      case 403: //Forbidden
        throw UnAuthorizedException(response.json()['details']);
      case 404: //Resource Not Found
        throw NotFoundException(response.json()['message'][0]);
      case 500: //Internal Server Error
      default:
        throw FetchDataException(
            'Something went wrong! ${response.statusCode}');
    }
  }
}
