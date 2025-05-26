
import 'package:dartz/dartz.dart';
import 'package:ecommerce/features/home/data/models/BannerModel.dart';

import '../../../../core/errors/failures.dart';
import '../models/CategoryModel.dart';
import '../models/ProductModel.dart';

abstract class HomeRepo {
 Future<Either<Failure, BannerModel>> getBanners();
  Future<Either<Failure, CategoriesModel>> getCategories();
 Future<Either<Failure, ProductModel>> getProducts();
}
