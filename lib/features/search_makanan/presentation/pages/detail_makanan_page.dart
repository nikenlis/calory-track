import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rasa/core/common/app_route.dart';
import 'package:rasa/core/theme/color_app.dart';
import 'package:rasa/core/ui/custom_button.dart';
import 'package:rasa/core/ui/shared_method.dart';
import 'package:rasa/features/search_makanan/presentation/bloc/detail_makanan/detail_makanan_bloc.dart';
import 'package:rasa/features/upload_makanan/domain/entities/upload_makanan_entity.dart';
import 'package:rasa/features/upload_makanan/presentation/widgets/form_items.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailMakananPage extends StatefulWidget {
  final String data;
  const DetailMakananPage({super.key, required this.data});

  @override
  State<DetailMakananPage> createState() => _DetailMakananPageState();
}

class _DetailMakananPageState extends State<DetailMakananPage> {
  int selectedTab = 0;
  VolumeEntity? selectedEntity;

  @override
  void initState() {
    super.initState();
    context.read<DetailMakananBloc>().add(GetDetailMakanan(name: widget.data));
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          title: Text(widget.data),
          backgroundColor: whiteColor,
        ),
        body: BlocConsumer<DetailMakananBloc, DetailMakananState>(
          listener: (context, state) {
            if (state is DetailMakananFailed) {
              if (state.message == 'Tidak ada koneksi internet.') {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoute.noConnectionPage, (route) => false);
              } else {
                showCustomSnackbar(context, state.message);
              }
            }
          },
          builder: (context, state) {
            if (state is DetailMakananLoading) {
              return Skeletonizer(
                enabled: true,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 16),

                    // Volume (dummy 3 item buat skeleton)
                    Text(
                      'Volume',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: bold,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: List.generate(3, (i) {
                        return Expanded(
                          child: Container(
                            height: 37,
                            margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(color: mainColor, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),
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
                                data: "100",
                                isShowIcon: true,
                                iconImage: 'assets/img_kalori.png',
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: DetailItems(
                                title: 'Karbohidrat',
                                data: "20",
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
                                data: "5",
                                isShowIcon: true,
                                iconImage: 'assets/img_protein.png',
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: DetailItems(
                                title: 'Lemak',
                                data: "3",
                                isShowIcon: true,
                                iconImage: 'assets/img_lemak.png',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 33),
                    FilledButtonItem(
                      onPressed: () {},
                      title: 'Selesai',
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            } else if (state is DetailMakananLoaded) {
              if (state.data.volumeList.isNotEmpty) {
                selectedEntity ??= state.data.volumeList.first;
              }

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 16),

                  // Pilihan Volume
                  if (state.data.volumeList.isNotEmpty) ...[
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
                        for (int i = 0; i < state.data.volumeList.length; i++)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTab = i;
                                  selectedEntity = state.data.volumeList[i];
                                });
                              },
                              child: Container(
                                height: 37,
                                margin: EdgeInsets.only(
                                    right: i < state.data.volumeList.length - 1
                                        ? 8
                                        : 0),
                                decoration: BoxDecoration(
                                  color:
                                      selectedTab == i ? mainColor : whiteColor,
                                  border:
                                      Border.all(color: mainColor, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  state.data.volumeList[i].volume,
                                  style: whiteTextStyle.copyWith(
                                    color: selectedTab == i
                                        ? whiteColor
                                        : mainColor,
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
                  ],

                  // Nutrisi (fallback kalau volume kosong)
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DetailItems(
                              title: 'Kalori',
                              data: selectedEntity?.nutritionInfo.kalori ??
                                  state.data.nutritionInfo.kalori,
                              isShowIcon: true,
                              iconImage: 'assets/img_kalori.png',
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: DetailItems(
                              title: 'Karbohidrat',
                              data: selectedEntity?.nutritionInfo.karbohidrat ??
                                  state.data.nutritionInfo.karbohidrat,
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
                              data: selectedEntity?.nutritionInfo.protein ??
                                  state.data.nutritionInfo.protein,
                              isShowIcon: true,
                              iconImage: 'assets/img_protein.png',
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: DetailItems(
                              title: 'Lemak',
                              data: selectedEntity?.nutritionInfo.lemak ??
                                  state.data.nutritionInfo.lemak,
                              isShowIcon: true,
                              iconImage: 'assets/img_lemak.png',
                            ),
                          ),
                        ],
                      ),
                    ],
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
                    title: 'Selesai',
                  ),
                  const SizedBox(height: 30),
                ],
              );
            }

            // state selain Loaded dan Loading
            return Center(
              child: Text(
                'Gagal memuat data.',
                style: greyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: regular,
                  color: greyColor.withValues(alpha: 0.4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
