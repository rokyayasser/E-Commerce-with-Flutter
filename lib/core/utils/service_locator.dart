import 'package:get_it/get_it.dart';

import '../../features/category/data/repos/category_repo.dart';
import '../../features/category/data/repos/category_repo_impl.dart';
import '../../features/home/data/repos/home_repo_impl.dart';
import 'api_service.dart';

final getIt = GetIt.instance;

void setup() {
  DioHelper.init();
  getIt.registerSingleton<DioHelper>(DioHelper());

  getIt.registerSingleton<HomeRepoImpl>(
    HomeRepoImpl(getIt<DioHelper>()),
  );

  getIt.registerSingleton<CategoryRepo>(
    CategoryRepoImpl(),
  );
}
