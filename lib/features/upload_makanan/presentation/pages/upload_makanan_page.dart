import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rasa/core/common/app_route.dart' show AppRoute;
import 'package:rasa/core/theme/color_app.dart';
import 'package:rasa/core/ui/shared_method.dart';
import 'package:rasa/features/upload_makanan/presentation/bloc/upload_makanan_bloc.dart';

import '../../../../core/ui/custom_button.dart';

class UploadMakananPage extends StatefulWidget {
  const UploadMakananPage({super.key});

  @override
  State<UploadMakananPage> createState() => _UploadMakananPageState();
}

class _UploadMakananPageState extends State<UploadMakananPage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final compressedFile = await compressImage(pickedFile);

      if (compressedFile != null) {
        setState(() {
          _imageFile = File(compressedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Makanan'),
      ),
      body: BlocConsumer<UploadMakananBloc, UploadMakananState>(
        listener: (context, state) {
          if (state is UploadMakananUploading) {
            showLoadingDialog(context);
          } else if (state is UploadMakananFailure) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            if (state.error == 'Tidak ada koneksi internet.') {
               Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.noConnectionPage,
                (route) => false
              );
            } else {
              showCustomSnackbar(context, state.error);
            }
            
          } else if (state is UploadMakananSuccess) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            if (state.data.foodName == 'gambar tidak dikenali') {
              showMakananNotDetectedDialog(context);
            } else {
              Navigator.pushNamed(
                context,
                AppRoute.resultPage,
                arguments: {'file': _imageFile, 'data': state.data},
              );
            }
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {
                  if (_imageFile == null) _pickImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    height: 195,
                    color: whiteColor,
                    child: _imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/img_upload.png',
                                width: 111,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Drop foto disini',
                                style: blackTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          )
                        : Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_imageFile != null) ...[
              OutlineButtonItem(
                onPressed: () {
                  _pickImage();
                },
                title: 'Change',
              ),
              SizedBox(
                height: 12,
              ),
            ],
            FilledButtonItem(
              onPressed: () {
                if (_imageFile == null) {
                  showCustomSnackbar(context, 'Please select an image first');
                  return;
                } else {
                  context
                      .read<UploadMakananBloc>()
                      .add(ScanUploadMakanan(file: File(_imageFile!.path)));
                }
              },
              title: 'Upload',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
