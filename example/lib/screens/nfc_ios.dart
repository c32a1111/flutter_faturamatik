import 'package:flutter/material.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';
import 'package:flutter_faturamatik/modules/id_capture.dart';
import 'package:flutter_faturamatik/modules/nfc_capture_ios.dart';
import 'package:flutter_faturamatik/common/models/nvi_data.dart';
import 'package:flutter_faturamatik/common/models/ios/nfc_info_messages.dart';

class IOSNFC extends StatefulWidget {
  const IOSNFC({Key? key}) : super(key: key);

  @override
  State<IOSNFC> createState() => IOSNFCState();
}

class IOSNFCState extends State<IOSNFC> {
  final _nfcCapture = FlutterFaturamatik().getIOSNFCCapture();
  final _idCapture = FlutterFaturamatik().getIDCapture();
  
  bool _isCompleted = false;

  String _dateOfBirth = "";
  String _documentNo = "";
  String _expireDate = "";

  Future<void> nfcModuleSetType() async {
    await _nfcCapture.setType("TUR_ID_1");
    await _nfcCapture.setNFCInfoMessage(
      NFCInfoMessages(
        tagError: "Kart okunamadı. Lütfen tekrar deneyin.",
        connectionError: "Bağlantı hatası oluştu.",
        successMessage: "Tebrikler! Başarıyla tamamlandı.",
        moreThanOneTag: "Çoklu kart tespit edildi",
        invalidMrzKey: "Geçersiz MRZ anahtarı",
        defaultMessage: "Bir hata oluştu.",
        responseError: "Hata oluştu.",
        requestPresentPass: "Kimliği temas ettirin.",
      ),
      );
  
  }

  @override
  void initState() {
    super.initState();
    nfcModuleSetType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IOS NFC Capture $_isCompleted"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          children: [
            Column(children: [
              TextField(
                decoration: const InputDecoration(
                    labelText: "Date of Birth", border: UnderlineInputBorder()),
                onChanged: (dateOfBirth) {
                  setState(() {
                    _dateOfBirth = dateOfBirth;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Document No", border: UnderlineInputBorder()),
                onChanged: (documentNo) {
                  setState(() {
                    _documentNo = documentNo;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Expire Date", border: UnderlineInputBorder()),
                onChanged: (expireDate) {
                  setState(() {
                    _expireDate = expireDate;
                  });
                },
              ),
            ]),
            Column(
              children: [
                OutlinedButton(
                    onPressed: () async {
                      if (_dateOfBirth != "" &&
                          _expireDate != "" &&
                          _documentNo != "") {
                        try {
                          final result = await _nfcCapture.startWithNviModel(
                            NviModel(_documentNo, _dateOfBirth, _expireDate),
                          );

                          print("---------------------------------------MRZ: ${result['mrz']}---------------------------------------");
                          print("Photo base64: ${result['photo']['base64']}");

                          setState(() {
                            _isCompleted = true; // veya başka bir state değişikliği
                          });
                        } catch (e) {
                          print("NFC Hatası: $e");
                        }
                      }
                    },
                    child: const Text("NVI Data Start (fields must be filled)"),
                  ),
                OutlinedButton(
                    onPressed: () {
                      _nfcCapture.startWithMRZCapture().then((isCompleted) {
                        setState(() {
                          _isCompleted = isCompleted;
                        });
                      });
                    },
                    child: const Text("MRZ Capture Start")),
                OutlinedButton(
                    onPressed: () {
                      _idCapture.start(IdSide.back).then((imageData) {
                        _nfcCapture
                            .startWithImageData(imageData)
                            .then((isDone) => setState(() {
                                  _isCompleted = isDone;
                                }));
                      });
                    },
                    child: const Text("Image Data Start (opens idCapture")),
                OutlinedButton(
                    onPressed: () {
                      if (_isCompleted == false) {
                        return;
                      } else {
                        _nfcCapture.upload();
                      }
                    },
                    child: const Text("Upload (last step)"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
