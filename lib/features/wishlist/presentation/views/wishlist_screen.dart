import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecommerce/features/home/presentation/views/widgets/product_details_screen.dart';
import 'package:ecommerce/features/home/presentation/views/widgets/product_details_screen.dart';
import '../../../home/data/models/ProductModel.dart';
import '../../../home/presentation/view_models/favourites_cubit/favorites_cubit.dart';
import '../../../home/presentation/view_models/home_cubit/home_cubit.dart';
import '../../../home/presentation/views/widgets/product_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double blockHorizontal = screenWidth / 100;
    double blockVertical = screenHeight / 100;

    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, homeState) {
          if (homeState is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (homeState is HomeFailure) {
            return const Center(child: Text('Failed to load data'));
          } else if (homeState is HomeLoaded) {
            return BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, favoritesState) {
                final favoriteProductIds =
                    BlocProvider.of<FavoritesCubit>(context).favoriteProductIds;
                final favoriteProducts = favoriteProductIds
                    .map((id) {
                      return homeState.products.data?.productList.firstWhere(
                        (product) => product.id == id,
                      );
                    })
                    .where((product) => product != null)
                    .cast<Data>()
                    .toList();

                if (favoriteProducts.isEmpty) {
                  return const Center(child: Text('No favorites yet'));
                }

                return SingleChildScrollView(
                  child: buildProductGrid(context, favoriteProducts,
                      blockHorizontal, blockVertical, screenWidth),
                );
              },
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }

  Widget buildProductGrid(BuildContext context, List<Data> products,
      double blockHorizontal, double blockVertical, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: blockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (screenWidth > 600) ? 3 : 2,
              childAspectRatio: (screenWidth > 600) ? 0.75 : 0.59,
              mainAxisSpacing: blockVertical * 2,
              crossAxisSpacing: blockHorizontal * 3,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(product: products[index]),
                  ),
                );
              },
              child: Material(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(blockHorizontal * 2),
                ),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(blockHorizontal * 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Hero(
                              tag: 'product_image_${products[index].id}',
                              child: Image.network(
                                products[index].image,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          if (products[index].discount != 0)
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                alignment: Alignment.center,
                                width: blockHorizontal * 20,
                                height: blockVertical * 3,
                                color: const Color(0xffF83758),
                                child: Text(
                                  'Discount'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: blockHorizontal * 3,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(blockHorizontal * 2),
                        child: Text(
                          products[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: blockHorizontal * 4,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(blockHorizontal * 2),
                        child: Row(
                          children: [
                            Text(
                              "\$${products[index].price.toInt()}",
                              style: TextStyle(
                                fontSize: blockHorizontal * 3.5,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: blockHorizontal * 2),
                            Text(
                              "\$${products[index].oldPrice}",
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
                                    .toggleFavoriteStatus(products[index].id);
                              },
                              child:
                                  BlocBuilder<FavoritesCubit, FavoritesState>(
                                builder: (context, state) {
                                  return CircleAvatar(
                                    radius: blockHorizontal * 4,
                                    backgroundColor: Colors.grey[200],
                                    child: Icon(
                                      BlocProvider.of<FavoritesCubit>(context)
                                              .isFavorite(products[index].id)
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
