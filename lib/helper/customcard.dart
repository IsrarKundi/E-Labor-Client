import 'package:e_labor/create_job/controllers/create_job_controller.dart';
import 'package:e_labor/create_job/views/create_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
class CustomCard extends StatelessWidget {
  final String title;
  final String icon;
  final bool isLoading; // To handle shimmer state

  const CustomCard({
    super.key,
    required this.title,
    required this.icon,
    this.isLoading = false, // Default is false, means data is loaded
  });

  @override
  Widget build(BuildContext context) {
    final CreateJobController createJobController = Get.put(CreateJobController());
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          Get.to(() => CreateJobScreen());
          createJobController.selectedCategory.value = title;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2.0,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 120,
                decoration: BoxDecoration(
                  color: Color(0xfff2f2f2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: isLoading
                    ? Shimmer(
                  duration: Duration(seconds: 2),
                  child: Container(
                    color: Colors.grey[300], // Placeholder color
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.network(
                    icon,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              isLoading
                  ? Shimmer(
                duration: Duration(seconds: 2),
                child: Container(
                  height: 20,
                  width: 80,
                  color: Colors.grey[300], // Placeholder for title
                ),
              )
                  : Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




Future<void> showCustomLoadingDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: PopScope(
          canPop: false,
          child: Center(
            child: SizedBox(
              height: 70,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: const [Colors.white],
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      );
    },
  );
}