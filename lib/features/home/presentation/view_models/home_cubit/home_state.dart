part of 'home_cubit.dart';


abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final BannerModel bannerModel;
  final CategoriesModel categoriesModel;
  final ProductModel products;

  HomeLoaded({
    required this.bannerModel,
    required this.categoriesModel,
    required this.products,
  });
}

class HomeFailure extends HomeState {
  final Failure failure;

  HomeFailure(this.failure);
}