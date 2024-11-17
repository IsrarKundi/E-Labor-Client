import 'package:e_labor/home/views/job_request_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
// import 'package:latlong2/latlong.dart';
import '../../authentication/controller/authentication_controller.dart';
import '../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class JobRequestsScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    controller.fetchJobRequests(); // Fetch data when the screen is built

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Requests'),
      ),
      body: Obx(() {
        if (controller.jobRequests.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.jobRequests.length,
          itemBuilder: (context, index) {
            final request = controller.jobRequests[index];
            final imageUrl = request.serviceProvider.image;
            print(imageUrl);

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image & Job Category
                    Row(
                      children: [
                        // Profile Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person, size: 60, color: Colors.grey[400]);
                            },
                          )
                              : Icon(Icons.person, size: 60, color: Colors.grey[400]),
                        ),
                        SizedBox(width: 16),
                        // Job Category
                        Expanded(
                          child: Text(
                            request.serviceProvider.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Job Information (Estimated Time & Offered Price)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Estimated Time
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              'Estimated Time: ${request.job.estimatedTime} hrs',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        // Offered Price

                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Offered Price:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey[700],),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${request.offeredPrice} PKR',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),

                    SizedBox(height: 6),
                    Text(
                      'Contact: ${request.serviceProvider.contact}',
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
                    ),
                    SizedBox(height: 8),

                    // Job Status
                    Text(
                      'Status: ${request.status}',
                      style: TextStyle(
                        color: request.status == 'completed' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.acceptJobRequest(request.id);
                              Get.offNamed(AppRoutes.MAINSCREEN);
                              // controller.fetchJobs();
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
                              'Accept',
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
          },
        );
      }),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          // Assuming `responseBody` is the API response body
          final responseBody = {
            "jobRequests": [
              {
                "_id": "6730c74b9179bddf93c2c77a",
                "jobId": {
                  "_id": "6730c7379179bddf93c2c768",
                  "category": "Plumber",
                  "estimatedTime": 4
                },
                "serviceProviderId": {
                  "_id": "67264dd03b67b1a899d31bf7",
                  "name": "dawar",
                  "contact": "dfghh",
                  "image": "https://res.cloudinary.com/dgxkxujec/image/upload/v1730564713/E_Labour/profile_pictures/file_hzuiqk.jpg"
                },
                "offeredPrice": 2500,
                "status": "pending",
                "createdAt": "2024-11-10T14:46:35.171Z"
              }
            ],
            "coordinates": [
              {
                "lng": 71.48199698431253,
                "lat": 34
              }
            ]
          };
          // Fetch user's current location using the Location class
          final userLocation = Location();
          await userLocation.getLocation();

          // Extract coordinates from the API response
          final coordinates = (responseBody['coordinates'] as List?)
              ?.map((coordJson) => Coordinate.fromJson(coordJson))
              .toList() ??
              [];

          // Add user's current location to the coordinates list
          // coordinates.add(Coordinate(latitude: userLocation.latitude, longitude: userLocation.longitude));

          print('All Coordinates: $coordinates');

          // Navigate to the MapScreen with coordinates
          if (coordinates.isNotEmpty) {
            Get.to(() => MapScreen(coordinates: coordinates, userLocation: LatLng(userLocation.latitude, userLocation.longitude)));
          } else {
            print('No coordinates available to display.');
          }


        },
        backgroundColor: Color(0xfff67322),
        child: Icon(Icons.location_on_outlined, color: Colors.white, size: 30), // Icon representing map
      ),
    );
  }
}
