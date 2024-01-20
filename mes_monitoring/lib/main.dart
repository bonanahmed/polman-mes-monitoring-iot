import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mes_monitoring/view/main_page.dart';
import 'package:mes_monitoring/view/side_view_page.dart';
import 'package:mes_monitoring/view/summary_page.dart';
import 'package:mes_monitoring/view/top_view_page.dart';

void main() async {
  await GetStorage.init();
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
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white, // Change this color to the desired color
            ),
          ),
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const MainPage()),
          GetPage(name: '/top', page: () => const TopViewPage()),
          GetPage(name: '/side', page: () => const SideViewPage()),
          GetPage(name: '/summary', page: () => const SummaryPage()),
        ],
        home: const MainPage());
  }
}
