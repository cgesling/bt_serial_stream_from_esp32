import 'dart:async';
import 'dart:convert' show ascii;

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// Future<List<BluetoothDevice>> bluetoothConnectionState() async {
//   List<BluetoothDevice> devices = [];
//   List<BluetoothDevice> devicesNotConnected = [];
//   List<BluetoothDevice> devicesConnected = [];
//   //create instance of bluetooth serial
//   FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

//   void getBondedDevices()async{
//   // get a list of the paired devices
//   devices = await bluetooth.getBondedDevices();
//   devices.forEach((element) {
//     if (element.isConnected) {
//       print('${element.name} is Connected');
//       devicesConnected.add(element);
//     } else {
//       print('${element.name} is Disconnected');
//       devicesNotConnected.add(element);
//     }
//   });
//
//
// }

// void discoverBluetoothDevices() {
//   List<BluetoothDiscoveryResult> results = [];
//   StreamSubscription streamSubscription =
//       FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
//     results.add(r);
//   });
//   streamSubscription.onDone(
//     () {
//       results.forEach((element) {
//         print(
//             'This Device is ON : ${element.device.name} --> ${element.device.address}');
//         //if (element.device.name == "ESP32-Testing BT") {
//         //   sendDataOn(element.device.address);
//         //}
//         streamSubscription.cancel();
//       });
//     },
//   );
//
// }

class CreateBluetoothDevice {
  CreateBluetoothDevice(
      {required this.deviceAddress, this.deviceName = 'No BroadCasted Name'});

  String deviceAddress;
  String? deviceName;
  BluetoothConnection? connection;

  // Future connection;

  // Future<BluetoothConnection> attemptConnection()async{
  //   BluetoothConnection connection = await BluetoothConnection.toAddress(this.deviceAddress);
  //   this.connection =  connection;
  //   return this.connection;
  // }

  void sendDataOn() async {
    //BluetoothConnection connection =
    // await BluetoothConnection.toAddress(deviceAddress);
    print('Connected to device and sending ON command : $deviceAddress');
    // send message
    var message = ascii.encode("ON" + "\r\n");
    connection!.output.add(message);
    await connection!.output.allSent;
  }

  void sendDataOff() async {
    //BluetoothConnection connection =
    //await BluetoothConnection.toAddress(deviceAddress);
    var message = ascii.encode("OFF" + "\r\n");
    connection!.output.add(message);
    await connection!.output.allSent;
  }

  void startConnection() async {
    connection = await BluetoothConnection.toAddress(deviceAddress);
  }

  void closeConnectionOnReselection(BluetoothDevice newDevice) {
    print('Checking if this Device already matches current socket device');
    if (this.deviceAddress != '') {
      print('${this} was already in use: ${this.deviceAddress}');
      if (this.connection != null) {
        print(
            'There seems to be a Connection to ${this.deviceAddress} still: Going to close this connection');
        this.connection!.finish();
      } else {
        print(
            'There was a device but it is no longer connected ${this.deviceAddress}');
      }

      //this.connection!.finish();
      // if ((this.deviceAddress == newDevice.address) &&
      //     (newDevice.isConnected)) {
      //   print('Final check to close this Connection');
      //   this.connection!.finish();
      // }
    }
  }
}
