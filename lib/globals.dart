import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'bluetooth_device.dart';
import 'dart:async';

String interiorBluetoothDeviceAddress = '';
CreateBluetoothDevice? interiorDevice;

String frontBluetoothDevice = '';
CreateBluetoothDevice? frontDevice;

String backBluetoothDevice = '';
CreateBluetoothDevice? backDevice;

String switchStateInterior = 'OFF';
String switchStateFront = 'OFF';
String switchStateBack = 'OFF';

String value = 'OFF';
String valueOn = 'ON';
String valueOff = 'OFF';

List<BluetoothDiscoveryResult> resultList =
    []; // should be populated from the bluetooth_settings.dart call to the subscriptionstream
List<String> list_items = [
  'Front',
  'Back',
  'Interior',
  'Livewell-Fill',
  'Livewell-Empty',
  'Nothing'
];
List<String> dropDownMenuButtonValuesList =
    []; // List fills with discoveredDevices originally as 'Nothing' then on a SetState the correct index is changed and reset to onChangedValue of dropdown

// Timer Countdown for turning on and countdown for turning off

// create a stream from a stream controller.
