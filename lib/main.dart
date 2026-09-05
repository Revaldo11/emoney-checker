import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'data/repositories/card_repository.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final cardRepository = CardRepository();
  await cardRepository.init();

  // Register sebagai permanent singleton supaya seluruh binding modul
  // (Home, Scan, History) bisa Get.find<CardRepository>() tanpa perlu
  // re-init Hive box berkali-kali.
  Get.put<CardRepository>(cardRepository, permanent: true);

  runApp(const EmoneyCheckerApp());
}

class EmoneyCheckerApp extends StatelessWidget {
  const EmoneyCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cek Saldo E-Money',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      getPages: AppPages.pages,
      theme: AppTheme.data,
    );
  }
}
