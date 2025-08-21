
import 'package:flutter/material.dart';
import 'package:rasa/features/home_page/home_page.dart';
import 'package:rasa/features/no_connection_page.dart';
import 'package:rasa/features/search_makanan/presentation/pages/detail_makanan_page.dart';
import 'package:rasa/features/upload_makanan/presentation/pages/scan_makanan_page.dart.dart';
import 'package:rasa/features/search_makanan/presentation/pages/search_makanan_page.dart';

import '../../features/upload_makanan/presentation/pages/result_page.dart' show ResultPage;
import '../../features/upload_makanan/presentation/pages/upload_makanan_page.dart';

class AppRoute {
  static const homePage = '/';
  static const uploadMakananPage = '/upload-makanan';
  static const scanMakananPage = '/scan-makanan';
  static const searchMakananPage = '/search-makanan';
  static const detailMakananPage = '/detail-makanan';
  static const resultPage = '/result';
  static const noConnectionPage = '/no-connection';


  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case uploadMakananPage:
      return MaterialPageRoute(builder: (context) => const UploadMakananPage());
    case scanMakananPage:
      return MaterialPageRoute(builder: (context) => const ScanMakananPage());
    case searchMakananPage:
      return MaterialPageRoute(builder: (context) => const SearchMakananPage());
    case detailMakananPage:
      final result = settings.arguments as String;
      return MaterialPageRoute(builder: (context) => DetailMakananPage(data: result));
    case resultPage:
      final result = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(builder: (context) => ResultPage(data: result));
    case noConnectionPage:
      return MaterialPageRoute(builder: (context) => const NoConnectionPage());
    default:
      return _notFoundPage;
  }
}

static MaterialPageRoute get _notFoundPage => MaterialPageRoute(builder: (context) => const Scaffold(
  body: Center(
    child: Center(
      child: Text('Page not Found'),
    ),
  ),
));
}

