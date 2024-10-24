import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:osfa_admin/controllor/home_controller.dart';
import 'package:osfa_admin/firebase_options.dart';
import 'package:osfa_admin/pages/home_page.dart';
import 'package:osfa_admin/themes/theme_provider.dart';

Future<void> main() async {
  //binding the databse by using the wigit flutterbind
  WidgetsFlutterBinding.ensureInitialized();
  //for using firebase
  await Firebase.initializeApp(options: firebaseOptions);
  // regester the home controller because of error
  Get.put(HomeController());
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter proj',
        theme: themeController.themeData.value,
       // theme: ThemeData(
            //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
       // ),
        home: HomePage(),
        // initialBinding: StoreBindings(),
      );
    });
  }
}

