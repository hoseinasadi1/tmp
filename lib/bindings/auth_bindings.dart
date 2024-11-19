import 'package:get/get.dart';
import 'package:lostandfound/controller/authentication_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    //Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<AuthenticationController>(AuthenticationController());
    // Get.put<GuardsandMemberController>(GuardsandMemberController());
    //Get.put<IncidentCallController>(IncidentCallController());
  }
}
