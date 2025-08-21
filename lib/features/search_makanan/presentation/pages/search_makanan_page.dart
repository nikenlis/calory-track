import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rasa/core/common/app_route.dart';
import 'package:rasa/core/theme/color_app.dart';
import 'package:rasa/core/ui/shared_method.dart';
import 'package:rasa/features/search_makanan/presentation/bloc/search_makanan/search_makanan_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchMakananPage extends StatefulWidget {
  const SearchMakananPage({super.key});

  @override
  State<SearchMakananPage> createState() => _SearchMakananPageState();
}

class _SearchMakananPageState extends State<SearchMakananPage> {
  TextEditingController searchController = TextEditingController();
  List<String> filteredData = [];
  bool isSearching = false;
  DateTime? _lastErrorTime; 
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Makanan'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CupertinoSearchTextField(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
              controller: searchController,
              autofocus: true,
              suffixInsets: const EdgeInsets.only(right: 16),
              suffixIcon: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: mainColor,
              ),
              prefixInsets: const EdgeInsets.only(left: 16),
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: greyColor,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: greyColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16, color: blackColor, fontWeight: medium),
              itemColor: greyColor,
              placeholder: 'Search makanan',
              placeholderStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16, color: greyColor, fontWeight: medium),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    isSearching = true;
                  });
                  Future.delayed(const Duration(milliseconds: 500), () {
                    context
                        .read<SearchMakananBloc>()
                        .add(GetSearchMakanan(query: value));
                  });
                } else {
                  setState(() {
                    isSearching = false;
                    filteredData = [];
                  });
                }
              },
              onSubmitted: (value) {
                context
                    .read<SearchMakananBloc>()
                    .add(GetSearchMakanan(query: value));
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<SearchMakananBloc, SearchMakananState>(
              listener: (context, state) {
                if (state is SearchMakananFailed) {
                  final now = DateTime.now();
                  if (_lastErrorTime == null ||
                      now.difference(_lastErrorTime!) > const Duration(seconds: 3)) {
                    showCustomSnackbar(context, state.message);
                    _lastErrorTime = now;
                  } else if (state.message == 'Tidak ada koneksi internet.') {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoute.noConnectionPage,
                      (route) => false,
                    );
                  }
                  setState(() {
                    isSearching = false;
                  });
                } else if (state is SearchMakananLoaded) {
                  setState(() {
                    filteredData = state.data;
                    isSearching = true;
                  });
                }
              },
              builder: (context, state) {
                if (state is SearchMakananLoading && filteredData.isEmpty) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 16),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: greyColor.withValues(alpha: 0.6),
                                width: 1, // konsisten tipis
                              ),
                            ),
                          ),
                          child: Text(
                            'dummyyyyy',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                    ),
                  );
                }

                if (isSearching) {
                  if (filteredData.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(top: 16),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.detailMakananPage,
                            arguments: filteredData[index],
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: greyColor.withValues(alpha: 0.6),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            filteredData[index],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
