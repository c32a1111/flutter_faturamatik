import 'package:flutter/material.dart';
import 'package:flutter_faturamatik/flutter_faturamatik.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
Future<void> initDelegates() async {
  FlutterFaturamatik().setDelegates().then((_) {

  });
    
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
                      Navigator.pushNamed(context, '/auto-selfie');
                    },
                    child: const Text('Auto Selfie')),
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
              ]),
        ));
  }
}
