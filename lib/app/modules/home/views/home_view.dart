import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cek Saldo')),
      body: Obx(() {
        if (controller.savedCards.isEmpty) {
          return const Center(child: Text('Belum ada kartu, coba scan dulu.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.savedCards.length,
          itemBuilder: (context, index) {
            final card = controller.savedCards[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(card.displayName),
                subtitle: Text('${card.cardTypeLabel} • ${card.readAt}'),
                trailing: Text('Rp ${card.balance}'),
                onTap: () => controller.goToCardDetail(card),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToScan,
        label: const Text('Scan kartu baru'),
        icon: const Icon(Icons.nfc),
      ),
    );
  }
}
