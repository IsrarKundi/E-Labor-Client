import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController{
  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  ///...............Get Categories Logic....................

  RxList<Category> categories = <Category>[].obs; // Add your categories here
  RxString selectedCategory = ''.obs;

  Future<void> fetchCategories() async {
    final url = Uri.parse('$baseUrl/client/job-categories');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      print('Fetching categories...');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',  // Add the token here
          'Content-Type': 'application/json', // Optional, if the API expects this
        },
      );

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');

        // Parse the JSON response
        final responseData = json.decode(response.body);
        List<dynamic> categoriesData = responseData['categories'];

        // Update the categories list with parsed data
        categories.assignAll(
          categoriesData.map((json) => Category.fromJson(json)).toList(),
        );
      } else {
        print('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }


// void setSelectedCategory(String category) {
//   selectedCategory.value = category;
//   print(selectedCategory.value);
// }

}


class Category {
  final String name;
  final String image;
  final int perHourRate;

  Category({
    required this.name,
    required this.image,
    required this.perHourRate,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      image: json['image'] as String,
      perHourRate: json['perHourRate'] as int,
    );
  }
}
