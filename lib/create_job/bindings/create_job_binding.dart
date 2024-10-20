
import 'package:e_labor/authentication/controller/authentication_controller.dart';
import 'package:e_labor/create_job/controllers/create_job_controller.dart';
import 'package:e_labor/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class CreateJobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateJobController>(
          () => CreateJobController(),
    );
  }
}