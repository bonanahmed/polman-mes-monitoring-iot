import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mes_monitoring/view/main_page.dart';
import 'package:mes_monitoring/view/side_view_page.dart';
import 'package:mes_monitoring/view/top_view_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white, // Change this color to the desired color
            ),
          ),
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => MainPage()),
          GetPage(name: '/top', page: () => TopViewPage()),
          GetPage(name: '/side', page: () => SideViewPage()),
        ],
        home: const MainPage());
  }
}
