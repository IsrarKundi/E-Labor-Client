import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';
import '../views/job_request_map_screen.dart';
import '../views/single_job_screen.dart';

class HomeController extends GetxController{
  final String baseUrl = 'https://e-labour-app.vercel.app/api/v1';
  RxList<Job> jobs = <Job>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();

    // fetchJobs();

  }

  ///......................Fetch Jobs.........................
  Future<void> fetchJobs() async {
    final url = Uri.parse('$baseUrl/client/jobs');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      print('Fetching jobs..................................');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');


      if (response.statusCode == 200) {
        print('Fetching Jobs Api response Body: ${response.body}');

        final responseData = json.decode(response.body);
        List<dynamic> jobsData = responseData['jobs'];

        jobs.assignAll(
          jobsData.map((json) => Job.fromJson(json)).toList(),
        );
      } else {
        print('Failed to fetch jobs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching jobs: $e');
    }
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

  // Method to delete a job
  Future<void> deleteJob(String jobId) async {
    Get.back();
    final url = Uri.parse('$baseUrl/client/delete-job/$jobId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      Center(child: CircularProgressIndicator());
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',  // Add the token here
          'Content-Type': 'application/json',
        },
      );

      // print('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        Get.snackbar('Success', data['message']);

        // Remove job from the list
        jobs.removeWhere((job) => job.id == jobId);
        // Get.back();
        print('Job deleted successfully');
      } else {
        final error = json.decode(response.body);
        print(error['message']);
        Get.snackbar('Error', error['message'] ?? 'Failed to delete job');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete job: $e');
    }
  }


  Future<void> fetchSingleJob(String jobId) async {
    final url = Uri.parse('$baseUrl/client/jobs/$jobId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      print('Fetching job details for job ID: $jobId...');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Job details fetched successfully.');
        final responseData = json.decode(response.body);
        final job = Job.fromJson(responseData);

        // Navigate to the SingleJobScreen with the job details
        Get.to(() => SingleJobScreen(job: job));
      } else {
        print('Failed to fetch job details: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load job details');
      }
    } catch (e) {
      print('Error fetching job details: $e');
      Get.snackbar('Error', 'Failed to load job details');
    }
  }


  var jobRequests = <JobRequest>[].obs;

  Future<void> fetchJobRequests() async {
    final url = '$baseUrl/client/job-requests';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print('Error: Auth token is null');
      Get.snackbar('Error', 'Authentication token is missing');
      return;
    }

    try {
      print('Fetching job requests...');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Job Request Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('fetching job request api response body: ${response.body}');

        if (data['jobRequests'] != null && data['jobRequests'] is List) {
          final requests = (data['jobRequests'] as List)
              .map((json) => JobRequest.fromJson(json ?? {}))
              .toList();
          jobRequests.value = requests;

          // Extract the coordinates and pass to the MapScreen
          final coordinates = jobRequests.value
              .expand((jobRequest) => jobRequest.coordinates)
              .toList();

          // Navigate to MapScreen with coordinates

        } else {
          print('Error: jobRequests key is missing or not a list');
          Get.snackbar('Error', 'Invalid data format from server');
        }
      } else {
        print('Failed to fetch job requests: ${response.statusCode}');
        throw Exception('Failed to load job requests');
      }
    } catch (e) {
      print('Error fetching job requests: $e');
      Get.snackbar('Error', 'Failed to load job requests');
    }
  }


  var isJobAccepted = false.obs; // Observable for tracking job acceptance status

  // Load Job Accepted Status from SharedPreferences
  Future<void> _loadJobAcceptedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isJobAccepted.value = prefs.getBool('isJobAccepted') ?? false;
  }

  // Accept Job Request API call
  Future<void> acceptJobRequest(String requestId) async {
    final url = '$baseUrl/client/job-requests/$requestId/accept';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print('Error: Auth token is null');
      Get.snackbar('Error', 'Authentication token is missing');
      return;
    }

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData["message"]); // Handle response message

        // Update flag and save to SharedPreferences
        isJobAccepted.value = true;
        await prefs.setBool('isJobAccepted', true);

        // Display success snackbar and close the current screen
        Get.snackbar('Success', responseData["message"]);
        Get.back();
      } else {
        print('Failed to accept job request: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to accept job request');
      }
    } catch (e) {
      print('Error accepting job request: $e');
      Get.snackbar('Error', 'An error occurred while accepting the job request');
    }
  }


  // Method to mark job as completed
  Future<void> markJobAsCompleted(String jobId) async {
    final url = Uri.parse('$baseUrl/client/mark-completed/$jobId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        fetchJobs();
        Get.defaultDialog(
          title: 'Job Completed!',
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Job marked as completed successfully!',
                  style: TextStyle(
                      fontSize: 16
                  ),
                  textAlign: TextAlign.center,),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          showReviewDialog(jobId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfff67322),
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Leave a Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        print('Failed to mark job as completed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking job as completed: $e');
    }
  }

  // Show review dialog
  void showReviewDialog(String jobId) {
    Get.defaultDialog(
      title: 'Submit Review',
      content: ReviewDialog(jobId: jobId, submitReview: submitReview),
    );
  }

  // Method to submit a review
  Future<void> submitReview(String jobId, int rating, String review) async {
    final url = Uri.parse('$baseUrl/client/add-review');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'jobId': jobId,
          'rating': rating,
          'review': review,
        }),
      );

      if (response.statusCode == 201) {
        Get.back();  // Close the review dialog
        Get.snackbar('Success', 'Review submitted successfully');
      } else {
        print('Failed to submit review: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting review: $e');
    }
  }
}

// Review dialog widget
class ReviewDialog extends StatefulWidget {
  final String jobId;
  final Future<void> Function(String, int, String) submitReview;

  ReviewDialog({required this.jobId, required this.submitReview});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 4;  // Default rating
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Column(
        children: [
          Text('Rate the Service'),
          SizedBox(height: 10),
          DropdownButton<int>(
            value: _rating,
            items: [1, 2, 3, 4, 5]
                .map((rating) => DropdownMenuItem(value: rating, child: Text(rating.toString())))
                .toList(),
            onChanged: (value) {
              setState(() {
                _rating = value ?? 4;
              });
            },
          ),
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(labelText: 'Write your review'),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    widget.submitReview(widget.jobId, _rating, _reviewController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfff67322),  // Use red to indicate deletion
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Submit Review',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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


///...............................Job Model Class...............................

class CompletedBy {
  final String id;
  final String name;
  final String contact;
  final double averageRating;
  final String image;

  CompletedBy({
    required this.id,
    required this.name,
    required this.contact,
    required this.averageRating,
    required this.image,
  });

  // Factory constructor to parse JSON data
  factory CompletedBy.fromJson(Map<String, dynamic> json) {
    return CompletedBy(
      id: json['_id'],
      name: json['name'],
      contact: json['contact'],
      averageRating: json['averageRating'].toDouble(),
      image: json['image'],
    );
  }
}

class Job {
  final String id;
  final String category;
  final String description;
  final int budget;
  final int estimatedTime;
  late final String status;
  final String imageUrl;
  final CompletedBy? completedBy;

  Job({
    required this.id,
    required this.category,
    required this.description,
    required this.budget,
    required this.estimatedTime,
    required this.status,
    required this.imageUrl,
    this.completedBy,
  });

  // Factory constructor to parse JSON data
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'],
      category: json['category'],
      description: json['description'],
      budget: json['budget'],
      estimatedTime: json['estimatedTime'],
      status: json['status'],
      imageUrl: json['imageUrl'],
      completedBy: json['completedBy'] is Map<String, dynamic>
          ? CompletedBy.fromJson(json['completedBy'])
          : null,
    );
  }
}


///................................Job Requests..................................

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({required this.latitude, required this.longitude});

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    // Ensure lat and lng are treated as doubles, even if they are ints
    return Coordinate(
      latitude: (json['lat'] is int ? (json['lat'] as int).toDouble() : json['lat'] ?? 0.0),
      longitude: (json['lng'] is int ? (json['lng'] as int).toDouble() : json['lng'] ?? 0.0),
    );
  }
}



class JobRequest {
  final String id;
  final Job1 job;
  final ServiceProvider serviceProvider;
  final int offeredPrice;
  final String status;
  final DateTime createdAt;
  final List<Coordinate> coordinates;

  JobRequest({
    required this.id,
    required this.job,
    required this.serviceProvider,
    required this.offeredPrice,
    required this.status,
    required this.createdAt,
    required this.coordinates,
  });

  factory JobRequest.fromJson(Map<String, dynamic> json) {
    // Parse coordinates from the 'coordinates' field if available
    final coordinates = (json['coordinates'] as List?)
        ?.map((coordJson) => Coordinate.fromJson(coordJson))
        .toList() ?? [];

    return JobRequest(
      id: json['_id'] ?? '',
      job: Job1.fromJson(json['jobId'] ?? {}),
      serviceProvider: ServiceProvider.fromJson(json['serviceProviderId'] ?? {}),
      offeredPrice: json['offeredPrice'] ?? 0,
      status: json['status'] ?? 'Unknown',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      coordinates: coordinates,
    );
  }
}



class Job1 {
  final String id;
  final String category;
  final int estimatedTime;

  Job1({
    required this.id,
    required this.category,
    required this.estimatedTime,
  });

  factory Job1.fromJson(Map<String, dynamic> json) {
    return Job1(
      id: json['_id'] ?? '',  // Default to empty string if null
      category: json['category'] ?? 'N/A',  // Default to 'N/A' if null
      estimatedTime: json['estimatedTime'] ?? 0,  // Default to 0 if null
    );
  }
}

class ServiceProvider {
  final String id;
  final String name;
  final String contact;
  final String image;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.contact,
    required this.image,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['_id'] ?? '',  // Default to empty string if null
      name: json['name'] ?? 'Unknown',  // Default to 'Unknown' if null
      contact: json['contact'] ?? 'N/A',  // Default to 'N/A' if null
      image: json['image'] ?? 'https://via.placeholder.com/150',  // Placeholder URL if imageUrl is null
    );
  }
}
