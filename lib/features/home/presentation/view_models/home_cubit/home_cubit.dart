import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/models/BannerModel.dart';
import '../../../data/models/CategoryModel.dart';

import '../../../data/models/ProductModel.dart';
import '../../../data/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(HomeInitial());

  void getHomeData() async {
    emit(HomeLoading());

    try {
      final bannerResponse = await homeRepo.getBanners();
      final categoriesResponse = await homeRepo.getCategories();
      final productsResponse = await homeRepo.getProducts(); // Add this line

      bannerResponse.fold(
        (failure) => emit(HomeFailure(failure)),
        (bannerModel) {
          categoriesResponse.fold(
            (failure) => emit(HomeFailure(failure)),
            (categoriesModel) {
              productsResponse.fold(
                (failure) => emit(HomeFailure(failure)),
                (productModel) => emit(HomeLoaded(
                  bannerModel: bannerModel,
                  categoriesModel: categoriesModel,
                  products: productModel, // Use the correct path
                )),
              );
            },
          );
        },
      );
    } catch (error) {
      emit(HomeFailure(ServerFailure(error.toString())));
    }
  }
}
