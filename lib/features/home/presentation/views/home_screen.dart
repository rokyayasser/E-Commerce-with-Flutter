import 'dart:math';

import 'package:ecommerce/features/cart/presentation/view_models/CartCubit.dart';
import 'package:ecommerce/features/home/presentation/views/widgets/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/service_locator.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/app_text_from_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/presentation/views/cart_screen.dart';
import '../../../category/presentation/views/category_screen.dart';
import '../../../wishlist/presentation/views/wishlist_screen.dart';
import '../../data/models/BannerModel.dart';
import '../../data/models/CategoryModel.dart';
import '../../data/models/ProductModel.dart';
import '../../data/repos/home_repo_impl.dart';
import '../view_models/favourites_cubit/favorites_cubit.dart';
import '../view_models/home_cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double blockHorizontal = screenWidth / 100;
    double blockVertical = screenHeight / 100;

    // List of screens to display based on selected index
    List<Widget> screens = [
      HomeScreenContent(), // Main content for the home screen
      WishlistScreen(), // Wishlist screen
      CartScreen(), // Cart screen
      // SearchScreen(), // Search screen
      //SettingsScreen(), // Settings screen
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(getIt<HomeRepoImpl>())..getHomeData(),
        ),
        BlocProvider(
          create: (context) => CartCubit(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CircleAvatar(
                radius: blockHorizontal * 5,
                backgroundColor: const Color(0xffF2F2F2),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/logo.png', height: blockVertical * 3),
              const Spacer(),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
            ],
          ),
        ),
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xffF83758),
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double blockHorizontal = screenWidth / 100;
    double blockVertical = screenHeight / 100;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: blockHorizontal * 5),
        child: Column(
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return Column(
                    children: [
                      buildShimmerBanner(blockVertical, blockHorizontal),
                      SizedBox(height: blockVertical * 2),
                      buildShimmerCategories(blockHorizontal, blockVertical),
                      SizedBox(height: blockVertical * 2),
                      buildShimmerProductGrid(
                          blockHorizontal, blockVertical, screenWidth),
                      SizedBox(height: blockVertical * 3),
                    ],
                  );
                } else if (state is HomeFailure) {
                  return Center(
                      child: Text('Error loading data: ${state.failure}'));
                } else if (state is HomeLoaded) {
                  return Column(
                    children: [
                      buildBanner(state.bannerModel.data, blockVertical,
                          blockHorizontal),
                      SizedBox(height: blockVertical * 2),
                      buildCategories(context, state.categoriesModel,
                          blockHorizontal, blockVertical),
                      SizedBox(height: blockVertical * 2),
                      buildProductGrid(
                          context,
                          state.products.data!.productList,
                          blockHorizontal,
                          blockVertical,
                          screenWidth),
                      SizedBox(height: blockVertical * 3),
                    ],
                  );
                } else {
                  return const Center(child: Text("No Data Available"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductGrid(BuildContext context, List<Data> products,
      double blockHorizontal, double blockVertical, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Products',
          style: GoogleFonts.montserrat(
            fontSize: blockHorizontal * 6,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: blockVertical * 2),
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
                child: SingleChildScrollView(
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
                              "\$${products[index].price.toInt() ?? 0}",
                              style: TextStyle(
                                fontSize: blockHorizontal * 3.5,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: blockHorizontal * 2),
                            Text(
                              "\$${products[index].oldPrice ?? 0}",
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
        ),
      ],
    );
  }

  Widget buildBanner(
      List<BannerData>? images, double blockVertical, double blockHorizontal) {
    return SizedBox(
      width: blockHorizontal * 90,
      height: blockVertical * 25,
      child: PageView.builder(
        itemCount: images?.length ?? 0,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(blockHorizontal * 2),
            child: Image.network(
              images![index].image!,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  Widget buildCategories(BuildContext context, CategoriesModel categoriesModel,
      double blockHorizontal, double blockVertical) {
    final categories = categoriesModel.dataAll.dataList;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: GoogleFonts.montserrat(
                fontSize: blockHorizontal * 6,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            AppTextButton(
              borderRadius: blockHorizontal * 2,
              backgroundColor: const Color(0xffF83758),
              buttonWidth: blockHorizontal * 25,
              buttonHeight: blockVertical * 4,
              buttonText: "View All",
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: blockHorizontal * 3.5,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoriesScreen(categoriesModel: categoriesModel),
                  ),
                );
              },
              icon: Icons.arrow_forward_sharp,
              iconColor: Colors.white,
              iconSize: blockHorizontal * 4.5,
            ),
          ],
        ),
        SizedBox(height: blockVertical * 2),
        SizedBox(
          height: blockVertical * 20,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryImage = category.image;

              return Padding(
                padding: EdgeInsets.only(right: blockHorizontal * 5),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: blockHorizontal * 12,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(categoryImage),
                    ),
                    SizedBox(height: blockVertical),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: blockHorizontal * 3.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildShimmerBanner(double blockVertical, double blockHorizontal) {
    return SizedBox(
      width: blockHorizontal * 90,
      height: blockVertical * 25,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: blockHorizontal * 2),
        ),
      ),
    );
  }

  Widget buildShimmerCategories(double blockHorizontal, double blockVertical) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: blockHorizontal * 20,
                height: blockVertical * 3,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: blockHorizontal * 25,
                height: blockVertical * 4,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: blockVertical * 2),
        SizedBox(
          height: blockVertical * 20,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: blockHorizontal * 5),
                child: Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        radius: blockHorizontal * 12,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: blockVertical),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: blockHorizontal * 20,
                        height: blockVertical * 2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildShimmerProductGrid(
      double blockHorizontal, double blockVertical, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: blockHorizontal * 30,
            height: blockVertical * 3,
            color: Colors.white,
          ),
        ),
        SizedBox(height: blockVertical * 2),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (screenWidth > 600) ? 3 : 2,
            childAspectRatio: (screenWidth > 600) ? 0.75 : 0.59,
            mainAxisSpacing: blockVertical * 2,
            crossAxisSpacing: blockHorizontal * 3,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
