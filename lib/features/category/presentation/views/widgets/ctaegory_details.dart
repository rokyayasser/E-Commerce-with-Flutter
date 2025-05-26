import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/service_locator.dart';
import '../../../../home/data/models/ProductModel.dart';
import '../../../../home/presentation/view_models/favourites_cubit/favorites_cubit.dart';
import '../../../../home/presentation/views/widgets/product_details_screen.dart';
import '../../../data/repos/category_repo.dart';
import '../../view_models/category_cubit/category_cubit.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const CategoryDetailsScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double blockHorizontal = screenWidth / 100;
    double blockVertical = screenHeight / 100;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryCubit(getIt<CategoryRepo>())
            ..getCategoryDetails(categoryId),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            categoryName,
            style: TextStyle(fontSize: blockHorizontal * 4),
          ),
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffF83758),
                ),
              );
            } else if (state is CategoryLoaded) {
              return Padding(
                padding: EdgeInsets.all(blockHorizontal * 4),
                child: ListView.separated(
                  itemCount:
                      state.categoryDetails.data?.productList.length ?? 0,
                  itemBuilder: (context, index) {
                    final product =
                        state.categoryDetails.data?.productList[index];
                    return _buildCategoryDetailItem(product, index, context,
                        blockHorizontal, blockVertical);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: blockVertical * 2);
                  },
                ),
              );
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildCategoryDetailItem(Data? product, int index,
      BuildContext context, double blockHorizontal, double blockVertical) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product!),
          ),
        );
      },
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(blockHorizontal * 2)),
        child: Container(
          width: double.infinity,
          height: blockVertical * 18,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(blockHorizontal * 2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    height: blockVertical * 18,
                    product?.image ?? '',
                    width: blockHorizontal * 40,
                    fit: BoxFit.fill,
                  ),
                  if (product?.discount != 0)
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        width: blockHorizontal * 20,
                        height: blockVertical * 2,
                        color: Colors.red,
                        child: Text(
                          'Discount'.toUpperCase(),
                          style: TextStyle(
                              fontSize: blockHorizontal * 3,
                              color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: blockHorizontal * 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: blockVertical * 1.5),
                      child: Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        product?.name ?? '',
                        style: TextStyle(
                          fontSize: blockHorizontal * 4,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: blockVertical * 1,
                          right: blockHorizontal * 2),
                      child: Row(
                        children: [
                          Text(
                            "\$${product?.price.toInt() ?? 0}",
                            style: TextStyle(
                                fontSize: blockHorizontal * 3.5,
                                color: Colors.red),
                          ),
                          SizedBox(width: blockHorizontal * 2),
                          Text(
                            "\$${product?.oldPrice ?? 0}",
                            style: TextStyle(
                              fontSize: blockHorizontal * 3.5,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              BlocProvider.of<FavoritesCubit>(context)
                                  .toggleFavoriteStatus(product!.id);
                            },
                            child: BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, state) {
                                return CircleAvatar(
                                  radius: blockHorizontal * 4,
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(
                                    BlocProvider.of<FavoritesCubit>(context)
                                            .isFavorite(product!.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: blockHorizontal * 4,
                                    color: Color(0xffF83758),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
