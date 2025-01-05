import 'package:get/get.dart';
import 'package:ticket_plane_app/units/connection/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
