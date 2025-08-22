import 'package:flutter/material.dart';

import 'package:rasa/core/common/app_route.dart';
import 'package:rasa/core/theme/color_app.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6.5,
          ),
          // Text(
          //   'Selamat Datang di Rasa',
          //   style: blackTextStyle.copyWith(
          //       fontSize: 20, fontWeight: bold,),
          // ),
          Text('Rasa',
              style: TextStyle(
                fontFamily: 'Yesteryear',
                fontSize: 52,
                fontWeight: semiBold,
                color: mainColor
              )),

          SizedBox(
            height: 4,
          ),
          Text(
            'Cari tahu gizi makanan khas Indonesia dengan praktis!',
            style: greyTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          SizedBox(
            height: 35,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoute.scanMakananPage);
            },
            child: Container(
              height: 97,
              decoration: BoxDecoration(
                border: Border.all(color: mainColor, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: ListTile(
                  leading: SizedBox(
                    width: 30,
                  ),
                  title: Text(
                    'Scan Makanan',
                    style: greyTextStyle.copyWith(
                        fontSize: 16, fontWeight: semiBold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: mainColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 13,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoute.uploadMakananPage);
            },
            child: Container(
              height: 97,
              decoration: BoxDecoration(
                border: Border.all(color: mainColor, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: ListTile(
                  leading: SizedBox(
                    width: 30,
                  ),
                  title: Text(
                    'Upload foto makanan',
                    style: greyTextStyle.copyWith(
                        fontSize: 16, fontWeight: semiBold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: mainColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 13,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoute.searchMakananPage);
            },
            child: Container(
              height: 97,
              decoration: BoxDecoration(
                border: Border.all(color: mainColor, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: ListTile(
                  leading: SizedBox(
                    width: 30,
                  ),
                  title: Text(
                    'Cari makanan',
                    style: greyTextStyle.copyWith(
                        fontSize: 16, fontWeight: semiBold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: mainColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
