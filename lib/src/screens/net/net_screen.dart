import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cell_info/CellResponse.dart';
import 'package:cell_info/cell_info.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class CounterFuntionsScreen extends StatefulWidget {
  const CounterFuntionsScreen({super.key});

  @override
  State<CounterFuntionsScreen> createState() => _CounterFuntionsScreenState();
}

class _CounterFuntionsScreenState extends State<CounterFuntionsScreen> {
  int clickCounter = 0;
  String currentDBM = "";
  var data = {};
  String mailStatus = "";
  int counter = 0;
  String email = "";
  int passInfo = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String dataTemp = "--";
    var details = {'cellInfo': {}, 'position': {}};
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String? platformVersion = await CellInfo.getCellInfo;
      final body = json.decode(platformVersion!);
      dataTemp = body.toString();
      details = {
        'cellInfo': body,
        'position': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'altitude': position.altitude,
          'speed': position.speed,
          'speedAccuracy': position.speedAccuracy,
          'heading': position.heading,
          'timestamp': position.timestamp,
        }
      };
    } on PlatformException {
      //_cellsResponse = null;
    }

    print(counter);
    print(passInfo);

    setState(() {
      counter++;
    });

    if (passInfo == 0) {
      setState(() {
        data = details;
      });
    }
  }

  Future<int> send() async {
    try {
      final url = Uri.parse('http://34.28.169.24/email/');
      //Response response = await get(url);
      // var url = Uri.https('34.28.169.24', 'email/');
      var response = await http.post(url, body: {
        'to': email,
        'subject': 'DEMO: Cell Signal Catcher',
        'message': data.toString(),
      });
      // print('mail status: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          mailStatus = 'Email sent';
        });
      } else {
        setState(() {
          mailStatus = 'Email not sent';
        });
      }
    } catch (e) {
      setState(() {
        mailStatus = e.toString();
      });
    }

    setState(() {
      counter = 0;
    });

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo: Cell Signal Catcher'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
              onChanged: (value) => setState(() {
                // print(value);
                email = value;
              }),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(icon: Icons.email, onPressed: send),
                const SizedBox(width: 10),
                Text(counter > 1 ? '' : mailStatus,
                    style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 10),
                CustomButton(
                    icon: Icons.refresh,
                    onPressed: () {
                      int val = 1;
                      if (passInfo == 1 || passInfo == '1') {
                        val = 0;
                      }
                      if (passInfo == 0) {
                        val = 1;
                      }

                      setState(() {
                        passInfo = val;
                      });
                    }),
              ],
            ),
            const SizedBox(height: 10),
            Text('Cell Info : $data', style: const TextStyle(fontSize: 9)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  late Timer timer;
  void startTimer() {
    const oneSec = Duration(seconds: 3);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        initPlatformState();
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const StadiumBorder(),
      enableFeedback: true,
      elevation: 5,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
