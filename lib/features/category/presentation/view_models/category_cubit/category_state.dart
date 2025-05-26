part of 'category_cubit.dart';

abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final ProductModel categoryDetails;

  CategoryLoaded(this.categoryDetails);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}