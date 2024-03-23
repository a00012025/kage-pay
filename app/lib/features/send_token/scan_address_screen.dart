import 'dart:convert';
import 'dart:io';

import 'package:app/features/send_token/send_token_screen.dart';
import 'package:app/features/stealth/stealth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanAddressScreen extends ConsumerStatefulWidget {
  const ScanAddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendTokenChooseAddressState();
}

class _SendTokenChooseAddressState extends ConsumerState<ScanAddressScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  bool stop = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (stop) {
        return;
      }

      setState(() {
        stop = true;
        result = scanData;
        try {
          final data = jsonDecode(scanData.code.toString());
          debugPrint('=======data : $data=========');
          final service = StealthService();
          final vPubPoint = service.getECPoint(data['pv'] as String);
          final kPubPoint = service.getECPoint(data['pk'] as String);
          final name = data['name'] as String;
          final result = service.getOthersAddress(vPubPoint, kPubPoint);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SendTokenScreen(
                name,
                result,
              ),
            ),
          );

          debugPrint('=======data : $data=========');
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : const Text(
                      '🥷 Scan a QR Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
