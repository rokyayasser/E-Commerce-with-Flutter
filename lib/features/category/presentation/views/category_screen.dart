import 'package:ecommerce/features/category/presentation/views/widgets/ctaegory_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/data/models/CategoryModel.dart';

class CategoriesScreen extends StatelessWidget {
  final CategoriesModel categoriesModel;

  const CategoriesScreen({super.key, required this.categoriesModel});

  @override
  Widget build(BuildContext context) {
    final categories = categoriesModel.dataAll.dataList;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffF83758),
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: const Color(0xffF83758),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Categories",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          final itemHeight = isWideScreen ? 150.0 : 130.0;
          final itemWidth = isWideScreen ? 150.0 : 130.0;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final category = categories[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsScreen(
                          categoryId: category.id,
                          categoryName: category.name,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        color: Colors.white,
                        height: itemHeight,
                        width: itemWidth,
                        child: Image.network(
                          category.image,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          category.name,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(thickness: 1),
              itemCount: categories.length,
            ),
          );
        },
      ),
    );
  }
}
