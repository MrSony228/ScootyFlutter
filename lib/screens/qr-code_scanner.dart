import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scooty/internet_engine.dart';

import '../model/transport.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QrCodeScannerScreen();
  }
}

class _QrCodeScannerScreen extends State<QrCodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      MobileScanner(
          allowDuplicates: false,
          controller: cameraController,
          onDetect: (barcode, args) async {
            final String? code = barcode.rawValue;
            Transport result =
                await InternetEngine().getTransportByQrCode(code!);
            Navigator.pop(context, result);
            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       return AlertDialog(
            //         backgroundColor: Colors.black,
            //         title: const Text("Qr-Code"),
            //         content: Text(
            //           result.id.toString() + result.name.toString(),
            //         ),
            //         actions: [
            //           ElevatedButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //               child: const Text("Закрыть"))
            //         ],
             //     );
               // });
          }),

      Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: const [
             SizedBox(height: 100,),
              Text("Поиск самоката", style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal, fontFamily: 'CeraPro'),  ),
              SizedBox(height: 10,),
              Text("Отсканируйте Qr-код на руле самоката", style: TextStyle(fontSize: 15, fontFamily: ""),),
            ],
          ),
        ),
      ),

      Center(
          child: SizedBox(
        width: 220,
        height: 220,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow, width: 5),
              borderRadius: BorderRadius.circular(8.0)),
        ),
      )),
      Container(
        padding: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              const SizedBox(height: 16,),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(MdiIcons.windowClose, color: Colors.white,), iconSize: 36,
              ),
            ],
          ),
        ),
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16),
          child: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff3B3D10),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.yellow,
                  ),
                ),
                child: IconButton(
                    onPressed: () => cameraController.toggleTorch(),
                    icon: ValueListenableBuilder(
                        valueListenable: cameraController.torchState,
                        builder: (context, state, child) {
                          switch (state as TorchState) {
                            case TorchState.off:
                              return const Icon(Icons.flashlight_on_outlined,
                                  color: Color(0xffEEF511));
                            case TorchState.on:
                              return const Icon(Icons.flashlight_off_outlined,
                                  color: Color(0xffEEF511));
                          }
                        })),
              ),
            ),
          ])))
    ]));
  }
}
