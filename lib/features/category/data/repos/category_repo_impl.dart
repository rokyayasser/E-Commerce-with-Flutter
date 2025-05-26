import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:ecommerce/core/errors/failures.dart';

import 'package:ecommerce/features/home/data/models/ProductModel.dart';

import '../../../../core/utils/api_service.dart';
import 'category_repo.dart';

class CategoryRepoImpl extends CategoryRepo {
  @override
  Future<Either<Failure, ProductModel>> getCategoryDetails(int categoryId) async {
    try {
      final response = await DioHelper.getData(
        path: "${ApiUrl.categories}/$categoryId",
        Token: '',
      );
      if (response.statusCode == 200) {
        return Right(ProductModel.fromJson(response.data));
      } else {
        return Left(ServerFailure.fromResponse(response.statusCode, response.data));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure("Unexpected error, please try again later"));
    }
  }

}