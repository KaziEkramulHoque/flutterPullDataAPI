import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillar_test/pages/pageOne.dart';
import 'package:pillar_test/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PillarTest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesClass.getPageOneRoute(),
      getPages: RoutesClass.routes,
    );
  }
}
