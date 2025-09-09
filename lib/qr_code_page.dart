import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'registration_page.dart';

class QrCodePage extends StatelessWidget {
  final String eventId;

  const QrCodePage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final registrationLink = "myapp://register?eventId=$eventId";

    return Scaffold(
      appBar: AppBar(title: const Text("Event Registration QR")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: registrationLink,
              size: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegistrationPage(eventId: eventId),
                  ),
                );
              },
              child: const Text("Open Registration Form"),
            )
          ],
        ),
      ),
    );
  }
}
