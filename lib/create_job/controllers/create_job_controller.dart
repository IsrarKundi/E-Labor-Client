import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:e_labor/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class CreateJobController extends GetxController{
  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';
  
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  RxString selectedCategory = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('Selected Category: ${selectedCategory.value}');
  }

  var jobImage = Rxn<File>();

  Future<void> pickImage(BuildContext context) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? photoTaken = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (photoTaken == null) return; // Exit early if no image is picked

      // Convert XFile to File
      File image = File(photoTaken.path);

      // Show a loading toast
      final cancelToast = BotToast.showLoading();

      // Assign the picked image to the reactive variable
      jobImage.value = image;

      cancelToast(); // Cancel the loading toast

    } on PlatformException {
      print('Failed to pick image');
    } finally {
      BotToast.cleanAll(); // Clean up any remaining toast notifications
    }
  }



  // Function to create a job
  // Function to create a job
  Future<void> createJob() async {
    // Check if required fields are filled
    if (selectedCategory.value.isEmpty ||
        descriptionController.text.isEmpty ||
        budgetController.text.isEmpty ||
        timeController.text.isEmpty) {
      // Show an error toast if required fields are empty
      BotToast.showText(text: "Please fill all the fields and select an image.");
      return;
    }

    try {
      // Show loading indicator
      final cancelToast = BotToast.showLoading();

      // Get the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        // If no token is found, show an error and return
        BotToast.showText(text: "Authentication error. Please log in again.");
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/client/create-job'),
      );

      // Add the Authorization header with the bearer token
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields (making sure values match API expectations)
      request.fields['category'] = selectedCategory.value;
      request.fields['description'] = descriptionController.text;
      request.fields['budget'] = budgetController.text;

      // Convert estimatedTime to integer
      int estimatedTime = int.tryParse(timeController.text) ?? 0;
      if (estimatedTime == 0) {
        BotToast.showText(text: "Please provide a valid estimated time.");
        cancelToast(); // Hide loading indicator
        return;
      }
      request.fields['estimatedTime'] = estimatedTime.toString();

      // Add the image as a MultipartFile
      if (jobImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            jobImage.value!.path,
            contentType: MediaType('image', 'jpeg'), // Adjust if your image isn't JPEG
          ),
        );
      }

      // Send the request
      var response = await request.send();
      print('Status Code:!!!!!  ${response.statusCode}');
      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await http.Response.fromStream(response);
        var jsonData = jsonDecode(responseData.body);
        BotToast.showText(text: "Job created successfully.");
        print('Job Created: $jsonData');
      } else {
        print('Failed to create job. Status code: ${response.statusCode}');
        var responseData = await http.Response.fromStream(response);
        print('Error Response: ${responseData.body}'); // Print the server's error message
        BotToast.showText(text: "Failed to create job.");
      }

      cancelToast(); // Hide loading indicator
    } catch (e) {
      BotToast.showText(text: "Error: ${e.toString()}");
      print('Error: $e');
    } finally {
      BotToast.cleanAll(); // Clean up any remaining toast notifications
    }
    descriptionController.clear();
    timeController.clear();
    budgetController.clear();
    jobImage.value = null;
    selectedCategory.value = '';
    Get.offAll(MainScreen(selectedIndex: 0));
  }



}