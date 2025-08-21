import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasa/core/common/app_route.dart';
import 'package:rasa/core/theme/color_app.dart';
import 'package:rasa/features/home_page/home_page.dart';
import 'package:rasa/features/injection.dart';
import 'package:rasa/features/search_makanan/presentation/bloc/detail_makanan/detail_makanan_bloc.dart';
import 'package:rasa/features/search_makanan/presentation/bloc/search_makanan/search_makanan_bloc.dart';
import 'package:rasa/features/upload_makanan/presentation/bloc/upload_makanan_bloc.dart';
import 'package:rasa/features/upload_makanan/presentation/pages/camera_service.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocator();
  cameras = await availableCameras();
  await CameraService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<UploadMakananBloc>()),
        BlocProvider(create: (_) => locator<SearchMakananBloc>()),
        BlocProvider(create: (_) => locator<DetailMakananBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
              color: backgorundColor,
              titleTextStyle: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              )),
          scaffoldBackgroundColor: backgorundColor,
          actionIconTheme: ActionIconThemeData(
            backButtonIconBuilder: (BuildContext context) {
              return const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: blackColor,
              );
            },
          ),
        ),
        home: const HomePage(),
        initialRoute: AppRoute.homePage,
        onGenerateRoute: AppRoute.onGenerateRoute,
      ),
    );
  }
}
