import 'package:e_labor/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../helper/customcard.dart';
import '../../profile/controller/profile_controller.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final List<Map<String, dynamic>> category = [
    {'title': 'Plumber', 'icon': Icons.plumbing},
    {'title': 'Meson', 'icon': Icons.construction},
    {'title': 'Labour', 'icon': Icons.pan_tool},
    {'title': 'Carpenter', 'icon': Icons.carpenter},
    {'title': 'Electrician', 'icon': Icons.electric_bolt},
    {'title': 'Painter', 'icon': Icons.format_paint},
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    final HomeController homeController = Get.put(HomeController());

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 33,),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                height: screenHeight * 0.6247,
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                  child: Column(
                    children: [

                      Expanded(
                        child: Obx(() {
                          if (homeController.categories.isEmpty) {
                            // Show shimmer placeholders if data is not yet loaded
                            return GridView.builder(
                              itemCount: 6, // Display 6 shimmer cards as placeholders
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                return CustomCard(
                                  title: '', // Placeholder title
                                  icon: '', // Placeholder icon
                                  isLoading: true, // Indicate that it's loading
                                );
                              },
                            );
                          } else {
                            // Show actual data once it's loaded
                            return GridView.builder(
                              itemCount: homeController.categories.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                final category = homeController.categories[index];
                                return CustomCard(
                                  title: category.name,
                                  icon: category.image,
                                );
                              },
                            );
                          }
                        }),
                      )
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