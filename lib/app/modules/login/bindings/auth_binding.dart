import 'package:get/get.dart';
import 'package:praktikum_mod_1/app/modules/login/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
