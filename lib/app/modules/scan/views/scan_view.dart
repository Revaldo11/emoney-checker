import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan kartu')),
      body: Obx(() {
        switch (controller.uiState.value) {
          case ScanUiState.waiting:
          case ScanUiState.reading:
            return _buildWaiting();
          case ScanUiState.success:
            return _buildSuccess();
          case ScanUiState.notRecognized:
            return _buildNotRecognized();
          case ScanUiState.error:
            return _buildError();
        }
      }),
    );
  }

  Widget _buildWaiting() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.nfc, size: 88),
          const SizedBox(height: 16),
          const Text('Mendeteksi kartu...'),
          const SizedBox(height: 8),
          const Text('Tempelkan kartu ke bagian belakang HP'),
          const SizedBox(height: 24),
          OutlinedButton(onPressed: controller.goBackToHome, child: const Text('Batal')),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    final result = controller.lastResult.value!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          Text('Rp ${result.balance}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(result.cardTypeLabel),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: controller.retry, child: const Text('Scan lagi')),
          TextButton(onPressed: controller.goBackToHome, child: const Text('Kembali ke home')),
        ],
      ),
    );
  }

  Widget _buildNotRecognized() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Kartu tidak dikenali'),
          const SizedBox(height: 8),
          const Text('Coba posisikan ulang kartu ke belakang HP'),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: controller.retry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber, size: 64, color: Colors.orange),
          const SizedBox(height: 16),
          Obx(() => Text(controller.errorMessage.value)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: controller.retry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
