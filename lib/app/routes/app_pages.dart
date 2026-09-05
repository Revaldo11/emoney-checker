import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/scan/bindings/scan_binding.dart';
import '../modules/scan/views/scan_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.scan,
      page: () => const ScanView(),
      binding: ScanBinding(),
    ),
    // TODO: tambah GetPage untuk history detail (lihat modules/history)
    // setelah HistoryController & HistoryView diimplementasikan —
    // pola binding-nya sama seperti Home & Scan di atas.
  ];
}
