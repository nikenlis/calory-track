import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rasa/core/api/api_config.dart';
import 'package:rasa/core/error/exceptions.dart';
import 'package:rasa/features/upload_makanan/data/models/upload_makanan_model.dart';

abstract class SearchMakananRemoteDatasource {
  Future<List<String>> searchMakanan({required String query});
  Future<UploadMakananModel> getMakananDetail({required String name});
}

class SearchMakananRemoteDatasourceImpl
    implements SearchMakananRemoteDatasource {
  final http.Client client;
  SearchMakananRemoteDatasourceImpl(this.client);

  @override
  Future<List<String>> searchMakanan({required String query}) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/food_search?query=$query');
      final response =
          await client.get(uri).timeout(const Duration(seconds: 10));

      final hasil = jsonDecode(response.body);
      final message = hasil['detail'] ?? 'Terjadi kesalahan.';

      if (response.statusCode == 200) {
        final List results = hasil['results'];
        return results.map<String>((e) => e['name'].toString()).toList();
      } else if (response.statusCode >= 500) {
        throw ServerException(message);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw ClientException(message);
      } else {
        throw UnexpectedException(
            'Status tidak diketahui: ${response.statusCode}');
      }
    } on TimeoutException {
      throw TimeoutException("Request timeout. Periksa koneksi internet Anda.");
    } on SocketException {
      throw ClientException("Tidak ada koneksi internet.");
    } catch (e) {
      throw UnexpectedException("Terjadi kesalahan tak terduga: $e");
    }
  }

  @override
  Future<UploadMakananModel> getMakananDetail({required String name}) async {
    try {
      Uri url = Uri.parse('${ApiConfig.baseUrl}/food_nutrition');
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'name': name}),
          )
          .timeout(const Duration(seconds: 5));

      final hasil = jsonDecode(response.body);
      final message = hasil['detail'] ?? 'Terjadi kesalahan.';
      print('Response: ${response.statusCode} - $hasil');

      if (response.statusCode == 200) {
        return UploadMakananModel.fromJson(hasil);
      } else if (response.statusCode >= 500) {
        throw ServerException(message);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw ClientException(message);
      } else {
        throw UnexpectedException(
          'Terjadi kesalahan: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw TimeoutException("Waktu permintaan habis.");
    } on SocketException {
      throw ClientException("Tidak ada koneksi internet.");
    } catch (e) {
      throw UnexpectedException("Terjadi kesalahan tak terduga: $e");
    }
  }
}
