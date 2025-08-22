import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:rasa/core/api/api_config.dart';
import 'package:rasa/core/error/exceptions.dart';
import 'package:rasa/features/upload_makanan/data/models/upload_makanan_model.dart';

abstract class UploadMakananRemoteDatasource {
  Future<UploadMakananModel> uploadMakanan({required File file});
}

class UploadMakananRemoteDatasourceImpl
    implements UploadMakananRemoteDatasource {
  final http.Client client;
  UploadMakananRemoteDatasourceImpl(this.client);

  @override
  Future<UploadMakananModel> uploadMakanan({required File file}) async {
    try {
      final mediaType = getMediaType(file);
      Uri url = Uri.parse('${ApiConfig.baseUrl}/scan_food');
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        file.path,
        contentType: mediaType,
      ));

      final streamedResponse =
          await client.send(request).timeout(const Duration(seconds: 10));

      final response = await http.Response.fromStream(streamedResponse);
      final hasil = jsonDecode(response.body);
      final message = hasil['detail'] ?? 'Terjadi kesalahan.';

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

  MediaType getMediaType(File file) {
    final ext = path.extension(file.path).toLowerCase();

    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return MediaType('image', 'jpeg');
      case '.png':
        return MediaType('image', 'png');
      case '.heic':
        return MediaType('image', 'heic');
      default:
        return MediaType('application', 'octet-stream');
    }
  }
}
