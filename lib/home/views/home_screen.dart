import 'package:e_labor/home/controllers/home_controller.dart';
import 'package:e_labor/home/views/categories_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../helper/customcard.dart';
import '../../main.dart';
import '../../profile/controller/profile_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
      body: Container(
        decoration: BoxDecoration(color :Color(0xffffa45b), ),
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 22, right: 22),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(
                    child:
                      Image.asset('images/logo.png', height: 33,),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location', style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16
                        ),
                        ),
                        Text('Saddar, Peshawar', style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                        ),
                      ],
                    ),
                    // SizedBox(width: 130,),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(() {
                          return InkWell(
                            onTap: (){
                              Get.offAll(MainScreen(selectedIndex: 3));
                            },
                            child: CircleAvatar(
                              radius: 30.0, // Adjust the radius as needed
                              backgroundImage: profileController.imageUrl.isNotEmpty
                                  ? NetworkImage(profileController.imageUrl.value) // Load from network if URL is available
                                  // : profileController.profileImage.value != null
                                  // ? FileImage(profileController.profileImage.value!) // Load from file if picked image is available
                                  : AssetImage('images/person.png') as ImageProvider, // Default asset image if both are null
                              backgroundColor: Colors.grey,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 22, bottom: 22),
                  child: Material(
                    color: Color(0xfff2f2f2),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search here...',
                         // Ensure no conflicting styles
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // setState(() {
                        //   searchQuery = value;
                        // });
                      },
                    ),
                  ),
                ),

              ],

            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hire a Service',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Choose the service you need',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  Get.to(() => CategoriesScreen());
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                label: Text('View All', style: TextStyle(color: Colors.black)),
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 2.0)),
                                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                  padding: MaterialStateProperty.all(EdgeInsets.only(left: 4, right: 8, top: 0, bottom: 0)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5), // Add some spacing between the button and the GridView
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
      ),




    );
  }
}
