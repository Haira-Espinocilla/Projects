import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QRDialog {
  static void showQRCode({
    required BuildContext context,
    required String dataToEncode,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFCFAEE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            'Generated QR Code',
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: const Color(0xFF5F7060),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: QrImageView(
                data: dataToEncode,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF5F7060),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.ubuntu(),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> scanQRCode(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFCFAEE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            'Scan QR Code',
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: const Color(0xFF5F7060),
            ),
          ),
        ),
        content: SizedBox(
          width: 300,
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: MobileScanner(
              fit: BoxFit.cover,
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                final String? scannedDocId = barcode.rawValue;

                if (scannedDocId != null) {
                  Navigator.of(context).pop(scannedDocId);
                }
              },
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF5F7060),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.ubuntu(),
            ),
          ),
        ],
      ),
    );
  }
}
