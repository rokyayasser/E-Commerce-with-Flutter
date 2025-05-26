import 'package:dartz/dartz.dart';
import 'package:ecommerce/features/home/data/models/ProductModel.dart';

import '../../../../core/errors/failures.dart';

abstract class CategoryRepo {
  Future<Either<Failure, ProductModel>> getCategoryDetails(int categoryId);
  }

