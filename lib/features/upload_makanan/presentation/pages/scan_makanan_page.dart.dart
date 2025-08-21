// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rasa/core/common/app_route.dart';
// import 'package:rasa/core/theme/color_app.dart';
// import 'package:rasa/core/ui/shared_method.dart';
// import 'package:rasa/features/upload_makanan/presentation/bloc/upload_makanan_bloc.dart';
// import 'package:rasa/features/upload_makanan/presentation/pages/camera_service.dart';

// class ScanMakananPage extends StatefulWidget {
//   const ScanMakananPage({super.key});

//   @override
//   State<ScanMakananPage> createState() => _ScanMakananPageState();
// }

// class _ScanMakananPageState extends State<ScanMakananPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   final _controller = CameraService().controller;
//   File? file;

//   @override
//   void initState() {
//     super.initState();

//     _animationController =
//         AnimationController(vsync: this, duration: const Duration(seconds: 2))
//           ..repeat(reverse: true);
//     _animation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   Future<void> _capture(BuildContext context) async {
//     if (_controller == null || !_controller.value.isInitialized) return;
//     final Xfile = await _controller.takePicture();
//     setState(() {
//       file = File(Xfile.path);
//     });
//     context
//         .read<UploadMakananBloc>()
//         .add(ScanUploadMakanan(file: File(Xfile.path)));
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   /// Kotak scanner + scan line (untuk setelah capture / uploading)
//   Widget _buildScannerWithLine() {
//     final size = MediaQuery.of(context).size;
//     final scanBoxSizeHeight = size.height * 0.7;
//     final scanBoxSizeWidth = size.width * 0.9;

//     // Jarak aman biar ga mentok border radius
//     final safePadding = 10;

//     return Center(
//       child: Stack(
//         children: [
//           Container(
//             width: scanBoxSizeWidth,
//             height: scanBoxSizeHeight,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white, width: 2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (_, __) {
//               // Range dari atas + safePadding sampai bawah - safePadding
//               final scanRange = scanBoxSizeHeight - safePadding * 2;

//               return Positioned(
//                 top: safePadding + _animation.value * scanRange,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 2, right: 2),
//                   child: Container(
//                     width: scanBoxSizeWidth - 4,
//                     height: 2,
//                     color: mainColor.withValues(alpha: 0.8),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<UploadMakananBloc, UploadMakananState>(
//       listener: (context, state) {
//         if (state is UploadMakananSuccess) {
//           if (state.data.foodName == 'gambar tidak dikenali') {
//             showMakananNotDetectedDialog(context);
//           } else if (mounted) {
//             Navigator.pushNamed(context, AppRoute.resultPage,
//                 arguments: {'file': file, 'data': state.data});
//           }
//         } else if (state is UploadMakananFailure) {
//           if (state.error == 'Tidak ada koneksi internet.') {
//             Navigator.pushNamedAndRemoveUntil(
//                 context, AppRoute.noConnectionPage, (route) => false);
//           } else {
//             showCustomSnackbar(context, state.error);
//           }
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Camera or Captured Image
//               if (state is UploadMakananPhotoCaptured ||
//                   state is UploadMakananUploading)
//                 SizedBox.expand(
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: Image.file(
//                       File((state as dynamic).file.path),
//                     ),
//                   ),
//                 )
//               else
//                 (_controller == null || !_controller.value.isInitialized)
//                     ? const Center(child: CircularProgressIndicator())
//                     : FittedBox(
//                         fit: BoxFit.cover,
//                         child: SizedBox(
//                           width: _controller.value.previewSize!.height,
//                           height: _controller.value.previewSize!.width,
//                           child: CameraPreview(_controller),
//                         ),
//                       ),

//               Stack(
//                 children: [
//                   ScannerOverlay(
//                     boxWidth: MediaQuery.of(context).size.width * 0.9,
//                     boxHeight: MediaQuery.of(context).size.height * 0.7,
//                   ),
//                   // _buildScannerBoxOnly(),
//                   if (state is UploadMakananPhotoCaptured ||
//                       state is UploadMakananUploading)
//                     _buildScannerWithLine(),
//                 ],
//               ),

//               // Tombol close
//               SafeArea(
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: CircleAvatar(
//                       backgroundColor: Colors.black45,
//                       child: IconButton(
//                         color: Colors.white,
//                         icon: const Icon(Icons.close),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // Tombol capture / ulangi
//               Positioned(
//                 bottom: 32, 
//                 left: 0,
//                 right: 0,
//                 child: SafeArea(
//                   child: Center(
//                     child: (state is UploadMakananPhotoCaptured ||
//                             state is UploadMakananUploading)
//                         ? Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 width: 72,
//                                 height: 72,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: whiteColor.withValues(alpha: 0.4),
//                                 ),
//                               ),
//                               Container(
//                                 width: 58,
//                                 height: 58,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: whiteColor,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 72,
//                                 height: 72,
//                                 child: AnimatedBuilder(
//                                   animation: _animationController,
//                                   builder: (_, __) {
//                                     // Map 0→1→0 jadi 0→2 "putaran"
//                                     final progress = _animationController
//                                                 .status ==
//                                             AnimationStatus.reverse
//                                         ? 1 + (1 - _animationController.value)
//                                         : _animationController.value;

//                                     return CircularProgressIndicator(
//                                       strokeWidth: 4,
//                                       value: progress %
//                                           1, // biar tiap naik & turun = full 1 rotasi
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           Colors.white),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           )
//                         : GestureDetector(
//                             onTap: () => _capture(context),
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Container(
//                                   width: 72,
//                                   height: 72,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: whiteColor.withValues(alpha: 0.2),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 58,
//                                   height: 58,
//                                   decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: whiteColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class ScannerOverlay extends StatelessWidget {
//   final double boxWidth;
//   final double boxHeight;
//   final double borderRadius;

//   const ScannerOverlay({
//     super.key,
//     required this.boxWidth,
//     required this.boxHeight,
//     this.borderRadius = 10,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size.infinite,
//       painter: _ScannerOverlayPainter(
//         boxWidth: boxWidth,
//         boxHeight: boxHeight,
//         borderRadius: borderRadius,
//       ),
//     );
//   }
// }

// class _ScannerOverlayPainter extends CustomPainter {
//   final double boxWidth;
//   final double boxHeight;
//   final double borderRadius;

//   _ScannerOverlayPainter({
//     required this.boxWidth,
//     required this.boxHeight,
//     required this.borderRadius,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.black.withOpacity(0.6);

//     // area penuh layar
//     final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);

//     // kotak tengah (scanner)
//     final holeRect = Rect.fromCenter(
//       center: size.center(Offset.zero),
//       width: boxWidth,
//       height: boxHeight,
//     );

//     final fullPath = Path()..addRect(fullRect);
//     final holePath = Path()
//       ..addRRect(
//           RRect.fromRectAndRadius(holeRect, Radius.circular(borderRadius)));

//     // gabungkan jadi "overlay berlubang"
//     final overlayPath = Path.combine(
//       PathOperation.difference,
//       fullPath,
//       holePath,
//     );

//     canvas.drawPath(overlayPath, paint);

//     // opsional: kasih border putih di lubangnya
//     final borderPaint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(holeRect, Radius.circular(borderRadius)),
//       borderPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }



import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rasa/core/common/app_route.dart';
import 'package:rasa/core/theme/color_app.dart';
import 'package:rasa/core/ui/shared_method.dart';
import 'package:rasa/features/upload_makanan/presentation/bloc/upload_makanan_bloc.dart';
import 'package:rasa/features/upload_makanan/presentation/pages/camera_service.dart';

class ScanMakananPage extends StatefulWidget {
  const ScanMakananPage({super.key});

  @override
  State<ScanMakananPage> createState() => _ScanMakananPageState();
}

class _ScanMakananPageState extends State<ScanMakananPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _controller = CameraService().controller;
  File? file;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _capture(BuildContext context) async {
    if (_controller == null || !_controller.value.isInitialized) return;
    final Xfile = await _controller.takePicture();
    setState(() {
      file = File(Xfile.path);
    });
    context
        .read<UploadMakananBloc>()
        .add(ScanUploadMakanan(file: File(Xfile.path)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildScannerWithLine(double boxHeight, double boxWidth) {
    final safePadding = 10;

    return Center(
      child: Stack(
        children: [
          Container(
            width: boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              final scanRange = boxHeight - safePadding * 2;
              return Positioned(
                top: safePadding + _animation.value * scanRange,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 2,
                  color: mainColor.withOpacity(0.8),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final boxHeight = screenSize.height * 0.6; // kotak scanner tinggi 60%
    final boxWidth = screenSize.width * 0.9; // kotak scanner lebar 90%
    final bottomPadding = 32.0;

    return BlocConsumer<UploadMakananBloc, UploadMakananState>(
      listener: (context, state) {
        if (state is UploadMakananSuccess) {
          if (state.data.foodName == 'gambar tidak dikenali') {
            showMakananNotDetectedDialog(context);
          } else if (mounted) {
            Navigator.pushNamed(context, AppRoute.resultPage,
                arguments: {'file': file, 'data': state.data});
          }
        } else if (state is UploadMakananFailure) {
          if (state.error == 'Tidak ada koneksi internet.') {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoute.noConnectionPage, (route) => false);
          } else {
            showCustomSnackbar(context, state.error);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Camera preview / captured image
              if (state is UploadMakananPhotoCaptured ||
                  state is UploadMakananUploading)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.file(
                      File((state as dynamic).file.path),
                    ),
                  ),
                )
              else
                (_controller == null || !_controller.value.isInitialized)
                    ? const Center(child: CircularProgressIndicator())
                    : FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.previewSize!.height,
                          height: _controller.value.previewSize!.width,
                          child: CameraPreview(_controller),
                        ),
                      ),

              // Scanner overlay + scan line
              ScannerOverlay(
                boxWidth: boxWidth,
                boxHeight: boxHeight,
              ),
              if (state is UploadMakananPhotoCaptured ||
                  state is UploadMakananUploading)
                _buildScannerWithLine(boxHeight, boxWidth),

              // Tombol close
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ),

              // Tombol capture / progress
              Positioned(
                bottom: bottomPadding,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Center(
                    child: (state is UploadMakananPhotoCaptured ||
                            state is UploadMakananUploading)
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor.withOpacity(0.4),
                                ),
                              ),
                              Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor,
                                ),
                              ),
                              SizedBox(
                                width: 86,
                                height: 86,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (_, __) {
                                    final progress =
                                        _animationController.status ==
                                                AnimationStatus.reverse
                                            ? 1 +
                                                (1 -
                                                    _animationController.value)
                                            : _animationController.value;
                                    return CircularProgressIndicator(
                                      strokeWidth: 4,
                                      value: progress % 1,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () => _capture(context),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: whiteColor.withOpacity(0.2),
                                  ),
                                ),
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Overlay scanner
class ScannerOverlay extends StatelessWidget {
  final double boxWidth;
  final double boxHeight;
  final double borderRadius;

  const ScannerOverlay({
    super.key,
    required this.boxWidth,
    required this.boxHeight,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScannerOverlayPainter(
        boxWidth: boxWidth,
        boxHeight: boxHeight,
        borderRadius: borderRadius,
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double boxWidth;
  final double boxHeight;
  final double borderRadius;

  _ScannerOverlayPainter({
    required this.boxWidth,
    required this.boxHeight,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.6);
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final holeRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: boxWidth,
      height: boxHeight,
    );

    final fullPath = Path()..addRect(fullRect);
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(holeRect, Radius.circular(borderRadius)));

    final overlayPath = Path.combine(PathOperation.difference, fullPath, holePath);

    canvas.drawPath(overlayPath, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(holeRect, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


