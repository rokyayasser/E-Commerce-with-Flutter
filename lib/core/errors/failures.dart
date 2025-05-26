import 'package:dio/dio.dart';

abstract class Failure{

  final String errMessage;

  const Failure(this.errMessage);


}

class ServerFailure extends Failure{
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioException dioException)
  {
    switch(dioException.type){

      case DioExceptionType.connectionTimeout:
        return ServerFailure("Connection Timeout with API server");
      case DioExceptionType.sendTimeout:
        return ServerFailure("Send Timeout with API server");
      case DioExceptionType.receiveTimeout:
        return ServerFailure("Receive Timeout with API server");
      case DioExceptionType.badCertificate:
        return ServerFailure("Bad certificate Error");
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(dioException.response!.statusCode!, dioException.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure("request to API server was cancelled");
      case DioExceptionType.connectionError:
        return ServerFailure("Connection Error");
      case DioExceptionType.unknown:
        if(dioException.message!.contains("SocketException")){
          return ServerFailure("No Internet Connection Error");
        }
        return ServerFailure("Unexpected Error, Please try later");
      default:
        return ServerFailure("Oops there was an error, Please try later!");
    }
  }
  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == null) {
      return ServerFailure("Invalid status code");
    }
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure("Your request not found, Please try later!");
    } else if (statusCode == 500) {
      return ServerFailure("Internal server error, Please try later!");
    } else {
      return ServerFailure("Oops there was an error, Please try later!");
    }
  }
}

