import 'package:e_labor/home/views/job_requests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class JobsScreen extends StatelessWidget {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.fetchJobs();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 33),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Jobs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: Obx(
                  () {
                if (controller.jobs.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.jobs.length,
                  itemBuilder: (context, index) {
                    final job = controller.jobs[index];
                    return GestureDetector(
                      onLongPress: () => _showDeleteDialog(context, job),
                      onTap: () {
                        if (job.status == 'in-progress' || job.status == 'completed') {
                          controller.fetchSingleJob(job.id);  // Fetch and navigate if status matches
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      job.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              job.category,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Spacer(),
                                            SizedBox(
                                              height: 30,
                                              child: OutlinedButton.icon(
                                                onPressed: () {
                                                  if (job.status == 'in-progress') {
                                                    controller.markJobAsCompleted(job.id);
                                                    // Action for marking job as finished
                                                    // controller.markJobAsCompleted(); // Add your job completion logic here
                                                  } if(job.status == 'completed'){
                                                    _showDeleteDialog(context, job);
                                                  }
                                                  if(job.status == 'open') {
                                                    // Navigate to JobRequestsScreen if status is not 'in-progress'
                                                    Get.off(() => JobRequestsScreen());
                                                  }
                                                },
                                                icon: Icon(
                                                  job.status == 'in-progress'
                                                      ? Icons.check_circle_outline
                                                      : Icons.arrow_forward_ios_rounded,
                                                  color: Color(0xfff67322),
                                                  size: 14,
                                                ),
                                                label: Text(
                                                  job.status == 'completed' ? 'Delete Job' : (job.status == 'in-progress' ? 'Mark as Completed' : 'Responses'),
                                                  style: TextStyle(
                                                    color: Color(0xfff67322),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                  side: MaterialStateProperty.all(BorderSide(color: Color(0xfff67322), width: 2.0)),
                                                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                  padding: MaterialStateProperty.all(EdgeInsets.only(left: 4, right: 8, top: 0, bottom: 0)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          job.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(height: 20, thickness: 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Budget',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text('${job.budget} pkr'),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Estimated Time',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text('${job.estimatedTime} hrs'),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        job.status,
                                        style: TextStyle(
                                          color: job.status == 'completed'
                                              ? Colors.pinkAccent
                                              : (job.status == 'in-progress'
                                              ? Colors.green
                                              : Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Job job) {
    Get.defaultDialog(
      title: 'Delete Job',
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete this job?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await controller.deleteJob(job.id);
                    await controller.fetchJobs();
                    Get.back(); // Close the dialog
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
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close the dialog without any action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Cancel button with a neutral color
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
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: true, // Prevent dialog from closing by tapping outside
    );
  }

}
