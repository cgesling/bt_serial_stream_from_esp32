import 'dart:async';
import 'package:flutter/material.dart';
import 'livewell_screen.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:bt_serial_stream_from_esp32/bluetooth_device.dart';
import 'package:bt_serial_stream_from_esp32/constants.dart';
import 'package:bt_serial_stream_from_esp32/globals.dart';
import 'package:bt_serial_stream_from_esp32/screens/bluetooth_settings.dart';

class LightScreen extends StatefulWidget {
  static const String id = 'light_screen';

  @override
  LightScreenState createState() {
    return LightScreenState();
  }
}

class LightScreenState extends State<LightScreen> {
  bool frontLightSwitch = false;

  String returnSwitchState(String currentState) {
    if (currentState == 'ON') {
      return 'OFF';
    } else
      return 'ON';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('Light Controller',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            )),
        actions: [
          IconButton(
            onPressed: (() {
              Navigator.pushNamed(context, LightScreen.id);
            }),
            icon: Icon(Icons.light_mode_outlined,
                size: 35.0, color: Colors.lightBlueAccent),
          ),
          IconButton(
            onPressed: (() {
              Navigator.pushNamed(context, LivewellScreen.id);
            }),
            icon: Icon(Icons.waves_sharp,
                size: 35.0, color: Colors.lightBlueAccent),
          ),
          IconButton(
            onPressed: (() {
              Navigator.pushNamed(context, BluetoothSettings.id);
            }),
            icon: Icon(Icons.settings, size: 35.0, color: Colors.white70),
          ),
        ],
      ),
      body: Container(
        child: Material(
          child: Flex(direction: Axis.vertical, children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     if (frontLightSwitch == true) {
                  //       frontLightSwitch = false;
                  //     } else {
                  //       frontLightSwitch = true;
                  //     }
                  //
                  //     setState(() {});
                  //     print('Front Light Card Tapped');
                  //   },
                  //   child: Card(
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(20.0))),
                  //       child: Row(
                  //         children: [
                  //           Container(
                  //             height: 20,
                  //             width: 70.0,
                  //             child: Switch(
                  //               value: frontLightSwitch,
                  //               activeColor: Colors.lightBlueAccent,
                  //               onChanged: (value) {
                  //                 frontLightSwitch = value;
                  //                 setState(() {});
                  //               },
                  //             ),
                  //           ),
                  //           Text(
                  //             'Front Lights',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.w200,
                  //               color: Colors.lightBlueAccent,
                  //               fontSize: 60.0,
                  //             ),
                  //           )
                  //         ],
                  //       )),
                  // ),
                  RoundedButton(
                    text: 'Front Lights - $switchStateFront',
                    onPressed: (() {
                      switchStateFront = returnSwitchState(switchStateFront);
                      if (switchStateFront == 'ON') {
                        print('Turning on Front Lights');
                        frontDevice!.sendDataOn();
                      }
                      if (switchStateFront == 'OFF') {
                        print('Turning Off Front Lights');
                        frontDevice!.sendDataOff();
                      }
                      setState(() {});
                    }),
                  ),
                  RoundedButton(
                    onPressed: (() {
                      switchStateInterior =
                          returnSwitchState(switchStateInterior);
                      if (switchStateInterior == 'ON') {
                        print('Turning on Interior Lights');
                        interiorDevice!.sendDataOn();
                        //sendDataOn(interiorBluetoothDeviceAddress);
                      }
                      if (switchStateInterior == 'OFF') {
                        print('Turning off Interior Lights');

                        interiorDevice!.sendDataOff();
                      }
                      setState(() {});
                    }),
                    text: 'Interior Lights - $switchStateInterior',
                  ),
                  RoundedButton(
                    onPressed: (() {
                      switchStateBack = returnSwitchState(switchStateBack);
                      if (switchStateBack == 'ON') {
                        print('Turning on Back Lights');
                        backDevice!.sendDataOn();
                        //sendDataOn(interiorBluetoothDeviceAddress);
                      }
                      if (switchStateBack == 'OFF') {
                        print('Turning off Back Lights');

                        backDevice!.sendDataOff();
                      }
                      setState(() {});
                    }),
                    text: 'Back Lights - $switchStateBack',
                  ),
                  SizedBox(
                    height: 200.0,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
