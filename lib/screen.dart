import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';
/*import 'package:wifi_connection/WifiConnection.dart';
import 'package:wifi_connection/WifiInfo.dart';*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);
  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  late Timer _timer;

  WifiInfoWrapper? _wifiObject;
  late final info ;
  late final wifiName ;
  @override
  void initState() {
    super.initState();
    setState(() {
      info = NetworkInfo() ;
    });
    gg();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      myFunction();
    });
  }

  void gg() async {
    String g = await info.getWifiName() ;
    setState(()  {
      wifiName = g ;
    });
  }

  Future<void> initPlatformState() async {
    WifiInfoWrapper? wifiObject;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
    } on PlatformException {

    }
    if (!mounted) return;

    setState(() {
      _wifiObject = wifiObject;
    });
  }

  bool b = false ; bool a = true ;
  TextEditingController ssid = TextEditingController();
  TextEditingController password = TextEditingController();
bool tap = false ;
  void myFunction() async {
    try {
      print('1');
      bool m = _wifiObject?.isHiddenSSid ?? false ;
      if (m) {
        print('2');
        bool l = _wifiObject!.ipAddress.isNotEmpty ?? false ;
        print(_wifiObject!.frequency.toString());
        if( tap && l && _wifiObject!.frequency > 1){
          setState(() {
            b = true;
            a = false;
          });
        }else{
          setState(() {
            b = false;
            a = true;
          });
        }
      } else {
        print('3');
        initPlatformState();
        print('Function called every 5 seconds');
        String jjjj = _wifiObject!.ssid ?? "ffg";
        if (jjjj == ssid.text) {
          print('4');
          setState(() {
            b = true;
            a = false;
          });
        } else {
          print('5');
          setState(() {
            b = false;
            a = true;
          });
        }
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> connectAndSendData() async {
    try {
      WiFiForIoTPlugin.connect( ssid.text,
          password: password.text,
          security: NetworkSecurity.WPA, );
      print("Connecting to ${ssid.text}");
      String h = ssid.text ;
      final snackBar = SnackBar(
        content: Text("Connecting to $h"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        b = true ;
        a = false ;
        tap = true ;
      });
      print("Data sent: A");
    } catch (e) {
      print("Failed to connect to WiFi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IoT Switch', style: TextStyle(fontWeight : FontWeight.w800)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          CircleAvatar(
            backgroundColor: b ? Colors.greenAccent : Colors.red,
            child: Center(
              child : b ? Icon(Icons.wifi, size: 70) : Icon(Icons.wifi_off_sharp, size : 70)
            ),
            radius : 80,
          ),
          SizedBox(height : 20),
          max(ssid, "Wifi SSID", "WIFIAHA"),
          max( password, "Wifi Password", "2670AN88"),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if( ssid.text.isEmpty || password.text.isEmpty ){
                  const snackBar = SnackBar(
                    content: Text('Please Type SSID and Password'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else if(password.text.length < 8 ){
                  const snackBar = SnackBar(
                    content: Text('Password must be 8 character in length'),
                  ) ;
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  connectAndSendData() ;
                }
              },
              child: b ? Text("ReConnect Wifi") : Text('Connect Wifi Now'),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              b ? ElevatedButton(
                onPressed: () async {
                  final String serverUrl = _wifiObject!.ipAddress; // Replace with your server IP address
                  final String stringValue = 'A';
                  try {
                    const snackBar = SnackBar(
                      content: Text('Sending A.........'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    final response = await http.post(
                      Uri.parse('$serverUrl/sendString'),
                      body: stringValue,
                      headers: {'Content-Type': 'text/plain'},
                    );

                    if (response.statusCode == 200) {
                      print('String sent successfully!');
                    } else {
                      print('Failed to send string. Status code: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error sending string: $e');
                  }
                  const snackBar = SnackBar(
                    content: Text('A sended Successfully'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text('Send "A"'),
              ) : SizedBox( ),
              b ? ElevatedButton(
                onPressed: () async {
                  final String serverUrl = _wifiObject!.ipAddress; // Replace with your server IP address
                  final String stringValue = 'B';
                  try {
                    const snackBar = SnackBar(
                      content: Text('Sending B.........'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    final response = await http.post(
                      Uri.parse('$serverUrl/sendString'),
                      body: stringValue,
                      headers: {'Content-Type': 'text/plain'},
                    );

                    if (response.statusCode == 200) {
                      print('String sent successfully!');
                    } else {
                      print('Failed to send string. Status code: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error sending string: $e');
                  }
                  const snackBar = SnackBar(
                    content: Text('B sended Successfully'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text('Send "B"')) : SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  Widget max(TextEditingController c, String label, String hint,) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label ,
          hintText: hint ,
          isDense: true ,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }



  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }
}
