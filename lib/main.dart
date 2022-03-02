import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmv_demo/pages/camera_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  cameras = await availableCameras();

  runApp(PMVDemo());
}

class PMVDemo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.yellow,
              fontSize: 20,
            )),
        primarySwatch: Colors.blue,
      ),
      home: CameraPage(),
    );
  }
}



