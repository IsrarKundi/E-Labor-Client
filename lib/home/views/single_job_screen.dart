import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class SingleJobScreen extends StatelessWidget {
  final Job job;

  const SingleJobScreen({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(job.imageUrl, height: 200, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              job.category,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(job.description),
            Divider(height: 20, thickness: 1),
            Text('Budget: ${job.budget} PKR'),
            Text('Estimated Time: ${job.estimatedTime} hrs'),
            Text(
              'Status: ${job.status}',
              style: TextStyle(
                color: job.status == 'completed' ? Colors.green : Colors.orange,
              ),
            ),
            SizedBox(height: 16),
            if (job.completedBy != null) ...[
              Text(
                'Completed By: ${job.completedBy!.name}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Contact: ${job.completedBy!.contact}'),
              Text('Average Rating: ${job.completedBy!.averageRating}'),
            ],
          ],
        ),
      ),
    );
  }
}
