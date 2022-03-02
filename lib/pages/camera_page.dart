import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_screenshot/native_screenshot.dart';

late List<CameraDescription> cameras;

class CameraPage extends StatefulWidget {
  CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;

  String modelo = "";
  bool menuHidden = false;

  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget cameraArea() {
    return new Stack(
      alignment: FractionalOffset.center,
      children: <Widget>[
        new Positioned.fill(
          child: new AspectRatio(aspectRatio: controller.value.aspectRatio, child: new CameraPreview(controller)),
        ),
        new Positioned.fill(
          top: MediaQuery.of(context).size.height / 3,
          child: new Opacity(
            opacity: 0.9,
            child: modelo != ""
                ? new Image.asset(
                    modelo,
                    fit: BoxFit.fitHeight,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget menuArea() {
    return Visibility(
      visible: !menuHidden,
      child: Positioned(
        bottom: 0.0,
        child: Column(
          children: [
            Row(
              children: [
                new ElevatedButton.icon(
                  onPressed: () async {
                    print("entered");

                    setState(() {
                      menuHidden = true;
                    });

                    Future.delayed(Duration(milliseconds: 500), () async {

                      String? path = await NativeScreenshot.takeScreenshot();

                      if( path == null || path.isEmpty ) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao capturar a imagem :('),
                              backgroundColor: Colors.red,
                            )
                        ); // showSnackBar()
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Imagem salva com sucesso $path')
                          )
                      );

                      setState(() {
                        menuHidden = false;
                      });

                      File imgFile = File(path);
                      ShowCapturedWidget(context, Image.file(imgFile));

                    });

                  },
                  icon: Icon(Icons.camera, color: Colors.white),
                  label: Text("Capturar"),
                )
              ],
            ),
            Row(
              children: [
                new ElevatedButton(
                    onPressed: () {
                      setState(() {
                        modelo = 'assets/images/DemoModel1.png';
                      });
                    },
                    child: Text("Modelo 1")),
                new Container(
                  width: 10,
                ),
                new ElevatedButton(
                    onPressed: () {
                      setState(() {
                        modelo = 'assets/images/DemoModel2.png';
                      });
                    },
                    child: Text("Modelo 2")),
                new Container(
                  width: 10,
                ),
                new ElevatedButton(
                    onPressed: () {
                      setState(() {
                        modelo = '';
                      });
                    },
                    child: Text("Limpar")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    return  Stack(alignment: FractionalOffset.center, children: <Widget>[
        cameraArea(),
        menuArea(),
      ]);
  }

  Future<dynamic> ShowCapturedWidget(BuildContext context, Image capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Capturado"),
        ),
        body: Center(child: capturedImage),
      ),
    );
  }
}
