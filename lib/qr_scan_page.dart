import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'registration_page.dart';

class QrScanPage extends StatelessWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR to Register")),
      body: MobileScanner(
        onDetect: (capture) {
          for (final barcode in capture.barcodes) {
            final code = barcode.rawValue;
            if (code != null) {
              Uri uri = Uri.parse(code);
              final eventId = uri.queryParameters['eventId'];

              if (eventId != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegistrationPage(eventId: eventId),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
