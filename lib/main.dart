import 'package:flutter/material.dart';
import 'package:bt_serial_stream_from_esp32/screens/light_screen.dart';
import 'package:bt_serial_stream_from_esp32/screens/livewell_screen.dart';
import 'package:bt_serial_stream_from_esp32/screens/bluetooth_settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BT_Serial',
        theme: ThemeData.dark(),
        initialRoute: LightScreen.id,
        routes: {
          LightScreen.id: (context) => LightScreen(),
          LivewellScreen.id: (context) => LivewellScreen(),
          BluetoothSettings.id: (context) => BluetoothSettings(),
        });
  }
}
