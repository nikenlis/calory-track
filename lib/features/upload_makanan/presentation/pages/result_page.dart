import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rasa/core/common/app_route.dart';
import 'package:rasa/core/theme/color_app.dart';
import 'package:rasa/core/ui/custom_button.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';
import 'package:rasa/features/upload_makanan/presentation/widgets/form_items.dart';

class ResultPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const ResultPage({super.key, required this.data});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int selectedTab = 0;
  late VolumeEntity selectedEntity;

  @override
  void initState() {
    super.initState();
    final entity = widget.data['data'] as UploadMakananEntity;
    selectedEntity = entity.volumeList.first;
  }

  @override
  Widget build(BuildContext context) {
    final entity = widget.data['data'] as UploadMakananEntity;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (didPop) {
          Future.microtask(() {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoute.homePage,
              (route) => false,
            );
          });
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 56),

            // Gambar
            Container(
              width: 290,
              height: 290,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.file(
                widget.data['file'] as File,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image,
                      color: mainColor.withValues(alpha: 0.4), size: 60);
                },
              ),
            ),
            const SizedBox(height: 45),

            // Nama Makanan
            DetailItems(
              title: 'Nama Makanan',
              data: entity.foodName,
            ),
            const SizedBox(height: 15),

            // Volume
            Text(
              'Volume',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: bold,
              ),
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                for (int i = 0; i < entity.volumeList.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = i;
                          selectedEntity = entity.volumeList[i];
                        });
                      },
                      child: Container(
                        height: 37,
                        margin: EdgeInsets.only(
                            right: i < entity.volumeList.length - 1 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: selectedTab == i ? mainColor : whiteColor,
                          border: Border.all(color: mainColor, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          entity.volumeList[i].volume,
                          style: whiteTextStyle.copyWith(
                            color: selectedTab == i ? whiteColor : mainColor,
                            fontWeight: regular,
                            fontSize: 12,
                            height: 16 / 12,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),

            // Nutrisi
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DetailItems(
                        title: 'Kalori',
                        data: selectedEntity.nutritionInfo.kalori,
                        isShowIcon: true,
                        iconImage: 'assets/img_kalori.png',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: DetailItems(
                        title: 'Karbohidrat',
                        data: selectedEntity.nutritionInfo.karbohidrat,
                        isShowIcon: true,
                        iconImage: 'assets/img_karbohidrat.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: DetailItems(
                        title: 'Protein',
                        data: selectedEntity.nutritionInfo.protein,
                        isShowIcon: true,
                        iconImage: 'assets/img_protein.png',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: DetailItems(
                        title: 'Lemak',
                        data: selectedEntity.nutritionInfo.lemak,
                        isShowIcon: true,
                        iconImage: 'assets/img_lemak.png',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            DetailItems(
              title: 'Score Prediksi',
              data: entity.confidence.toString(),
            ),

            const SizedBox(height: 33),
            FilledButtonItem(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoute.homePage,
                    (route) => false,
                  );
                },
                title: 'Selesai'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
