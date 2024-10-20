import 'package:e_labor/create_job/controllers/create_job_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../profile/controller/profile_controller.dart';

class CreateJobScreen extends StatelessWidget {
  const CreateJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateJobController createJobController = Get.put(CreateJobController());

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 33,),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text('My Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 36),
              GestureDetector(
                onTap: (){
                  createJobController.pickImage(context);
                },
                child:
                Obx(()=>
                    Container(
                      height: 260, // Set your desired height
                      decoration: BoxDecoration(
                        color: Color(0xfffef1e9), // Fill color for the container
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Color(0xFFF67322), // Border color
                          width: 2.0,
                        ),
                        image: DecorationImage(
                          image: createJobController.jobImage.value != null
                              ? FileImage(createJobController.jobImage.value!) // Display picked image
                              : AssetImage('images/image_icon.png') as ImageProvider,
                          fit: BoxFit.cover, // Make the image cover the whole container
                        ),
                      ),
                    )
                )
              ),


              SizedBox(height: 16,),
              Container(
                height: 52,
                width: 330,
                decoration: BoxDecoration(
                  color: Color(0xfffef1e9), // Fill color for the container
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Color(0xFFF67322), // Border color
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: TextField(
                    controller: createJobController.descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Job Description...',
                      border: InputBorder.none, // Remove default border
                      hintStyle: TextStyle(color: Colors.grey), // Hint text style (optional)
                      filled: true,
                      fillColor: Color(0xfffef1e9), // Ensures fill color inside the TextField too
                    ),
                    maxLines: null, // Allows the text field to expand vertically if needed
                    style: TextStyle(fontSize: 16), // Text style for user input
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                height: 52,
                width: 330,
                decoration: BoxDecoration(
                  color: Color(0xfffef1e9), // Fill color for the container
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Color(0xFFF67322), // Border color
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: TextField(
                    controller: createJobController.budgetController,
                    decoration: InputDecoration(
                      hintText: 'You Budget...',
                      border: InputBorder.none, // Remove default border
                      hintStyle: TextStyle(color: Colors.grey), // Hint text style (optional)
                      filled: true,
                      fillColor: Color(0xfffef1e9), // Ensures fill color inside the TextField too
                    ),
                    maxLines: null, // Allows the text field to expand vertically if needed
                    style: TextStyle(fontSize: 16), // Text style for user input
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                height: 52,
                width: 330,
                decoration: BoxDecoration(
                  color: Color(0xfffef1e9), // Fill color for the container
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Color(0xFFF67322), // Border color
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: TextField(
                    controller: createJobController.timeController,
                    decoration: InputDecoration(
                      hintText: 'Estimated Time...',
                      border: InputBorder.none, // Remove default border
                      hintStyle: TextStyle(color: Colors.grey), // Hint text style (optional)
                      filled: true,
                      fillColor: Color(0xfffef1e9), // Ensures fill color inside the TextField too
                    ),
                    maxLines: null, // Allows the text field to expand vertically if needed
                    style: TextStyle(fontSize: 16), // Text style for user input
                  ),
                ),
              ),
              SizedBox(height: 28,),
              GestureDetector(
                onTap: (){
                  createJobController.createJob();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 56,
                  width: 330,
                  decoration: BoxDecoration(
                    color: Color(0xFFF67322), // Fill color for the container
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Color(0xFFF67322), // Border color
                      width: 2.0,
                    ),
                  ),
                  child: Text('Post Job', style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
