import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:rasa/core/theme/color_app.dart';

void showCustomSnackbar(BuildContext context, String message) {
  Flushbar(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    messageColor: Colors.red,
    borderColor: const Color(0xFFF44336),
    icon: Icon(
      Icons.info_outline_rounded,
      color: Colors.red,
    ),
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.red.shade50,
    borderRadius: BorderRadius.circular(16),
    duration: const Duration(seconds: 2),
  ).show(context);
}

Future<void> showMakananNotDetectedDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: mainColor, size: 120),

              const SizedBox(height: 20),

              Text(
                'Gambar tidak dikenali',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Model ini hanya dapat mengenali 10 jenis makanan Indonesia: Bakso Daging Sapi, Bebek Betutu, Gado-Gado, Gudeg, Nasi Goreng, Pempek, Rawon, Rendang, Sate Ayam, Soto Ayam.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: greyColor,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // ✅ Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Dialog tidak bisa ditutup dengan klik di luar
    builder: (context) {
      return Center(
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          ),
        ),
      );
    },
  );
}

Future<XFile?> compressImage(XFile imageFile) async {
  final outputPath = "${imageFile.path}_compressed.jpg";

  // Kompres gambar
  XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
    imageFile.path, // Path input gambar
    outputPath, // Path output gambar
    quality: 70, // Kualitas kompresi (0-100)
  );

  return compressedFile;
}
