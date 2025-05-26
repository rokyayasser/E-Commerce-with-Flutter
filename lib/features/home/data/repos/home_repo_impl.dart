import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/features/home/data/models/BannerModel.dart';
import 'package:ecommerce/features/home/data/models/CategoryModel.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/api_service.dart';
import '../models/ProductModel.dart';
import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  final DioHelper dioHelper;

  HomeRepoImpl(this.dioHelper);

  @override
  Future<Either<Failure, BannerModel>> getBanners() async {
    try {
      final response = await DioHelper.getData(path: ApiUrl.banners, Token: '');
      if (response.data == null) {
        return Left(ServerFailure("No data received from server"));
      }
      final bannerModel = BannerModel.fromJson(response.data);
      return Right(bannerModel);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoriesModel>> getCategories() async {
    try {
      final response =
          await DioHelper.getData(path: ApiUrl.categories, Token: '');
      if (response.data == null) {
        return Left(ServerFailure("No data received from server"));
      }
      final categoriesModel = CategoriesModel.fromJson(response.data);
      return Right(categoriesModel);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProducts() async {
    try {
      final response =
          await DioHelper.getData(path: ApiUrl.products, Token: '');
      if (response.data == null) {
        return Left(ServerFailure("No data received from server"));
      }
      final products = ProductModel.fromJson(response.data);
      return Right(products);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
