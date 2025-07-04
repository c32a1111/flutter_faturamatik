import 'package:flutter/material.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _idCapture = FlutterFaturamatik().getIDCapture();

  Future<void> initDelegates() async {
  FlutterFaturamatik().setDelegates();
  FlutterFaturamatik().setEnvironment("deneme");
    
    await for (final delegateEvent in FlutterFaturamatik().getDelegateStream()) {
      print("delegate event recievedDDDD");
      print(delegateEvent);
    }
  }

  @override
  void initState() {
    super.initState();
    initDelegates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Faturamatik Flutter SDK Demo')),
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/id-capture");
                    },
                    child: const Text('ID Capture')),
                OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/pose-estimation');
                },
                child: const Text('Pose Estimation')),
                
                OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/nfc');
                },
                
                child: const Text('NFC')),

                OutlinedButton(
                onPressed: () async {
                  final result = await _idCapture.upload();
            
                  final bool isSuccess = result['status'];
                  final String message = result['message'];

                  print("home screen upload button func: $result");
                },
                
                child: const Text('Upload')),
              ]),
        ));
  }
}
