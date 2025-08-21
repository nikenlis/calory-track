import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rasa/core/common/app_route.dart';
import 'package:rasa/core/common/network_info.dart';
import 'package:rasa/core/theme/color_app.dart';
import 'package:rasa/core/ui/custom_button.dart';
import 'package:rasa/core/ui/shared_method.dart';

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({super.key});

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  Future<void> _checkConnection(BuildContext context) async {
    final networkInfo = NetworkInfoImpl(connectivity: Connectivity());

    bool online = await networkInfo.isConnected();

    if (online) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoute.homePage,
        (route) => false,
      );
    } else {
      showCustomSnackbar(
        context,
        'Koneksi internet terputus. Coba periksa jaringan Anda.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration:
                      BoxDecoration(color: mainColor.withValues(alpha: 0.2)),
                  child: Icon(Icons.wifi_off, size: 60, color: mainColor),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Tidak Ada Koneksi Internet',
                style: blackTextStyle.copyWith(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Perangkat Anda sedang offline.\nSilakan periksa koneksi Anda dan coba lagi.',
                textAlign: TextAlign.center,
                style: greyTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              FilledButtonItem(
                title: 'Coba lagi',
                onPressed: () {
                  _checkConnection(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
