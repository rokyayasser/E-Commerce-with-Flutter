import 'package:bloc/bloc.dart';
import 'package:ecommerce/features/home/data/models/ProductModel.dart';

import '../../../data/repos/category_repo.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepo categoryRepo;

  CategoryCubit(this.categoryRepo) : super(CategoryLoading());

  void getCategoryDetails(int categoryId) async {
    emit(CategoryLoading());
    final result = await categoryRepo.getCategoryDetails(categoryId);

    result.fold(
      (failure) => emit(CategoryError(failure.errMessage)),
      (categoryDetails) => emit(CategoryLoaded(categoryDetails)),
    );
  }
}
