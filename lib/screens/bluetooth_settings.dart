import 'dart:async';
import 'package:bt_serial_stream_from_esp32/bluetooth_device.dart';
import 'package:bt_serial_stream_from_esp32/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'package:bt_serial_stream_from_esp32/globals.dart';
import 'package:bt_serial_stream_from_esp32/screens/light_screen.dart';
import 'package:bt_serial_stream_from_esp32/screens/livewell_screen.dart';

class BluetoothSettings extends StatefulWidget {
  static const String id = 'bluetooth_settings';
  @override
  _DiscoverBluetoothDevices createState() => _DiscoverBluetoothDevices();
}

class _DiscoverBluetoothDevices extends State<BluetoothSettings> {
  //List<BluetoothDiscoveryResult> resultList = [];
  List<BluetoothDiscoveryResult> discoveredDevices = [];
  List<Widget> loadingIconInList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //we have to clear our dropDownMenuButtonValuesList
    dropDownMenuButtonValuesList.clear();
  }

  void discoverBluetoothDevices() {
    ;
    dropDownMenuButtonValuesList.forEach((element) {
      print('dropDownMenuButtonValuesList: $element');
    });
    discoveredDevices.forEach((element) {
      print('discoveredDevices: $element');
    });
    loadingIconInList.add(
      CircularProgressIndicator(),
    );
    StreamSubscription streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      //resultList.add(r);
      discoveredDevices.add(r);
      dropDownMenuButtonValuesList.add('Nothing');
      setState(() {});
    });

    streamSubscription.onDone(() {
      print('This is inside the subscription stream onDone Method');
      loadingIconInList.clear();
      setState(() {});
      streamSubscription.cancel();
      print('BluetoothSubscription Stream was cancelled');
    });
  }

  final dropdownMenuOptions = list_items
      .map((String item) =>
          new DropdownMenuItem<String>(value: item, child: new Text('$item')))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('Settings',
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
            onPressed: (() {}),
            icon: Icon(Icons.settings, size: 35.0, color: Colors.white70),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: RoundedButton(
                  text: 'Discover Bluetooth Devices',
                  onPressed: (() {
                    if (dropDownMenuButtonValuesList.length > 0) {
                      dropDownMenuButtonValuesList.clear();
                    }
                    if (discoveredDevices.length > 0) {
                      print('List still has widgets');
                      discoveredDevices.clear();
                      dropDownMenuButtonValuesList.clear();

                      setState(() {
                        //clearing screen of the discoveredDevice widgets
                      });
                    }

                    discoverBluetoothDevices();
                  }),
                ),
              ),
              SizedBox(width: 10),
              Column(
                children: loadingIconInList,
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: discoveredDevices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (() {}),
                  tileColor: Colors.black12,
                  title: Text(
                    '${discoveredDevices[index].device.name.toString()}',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w200,
                        color: Colors.lightBlueAccent),
                  ),
                  subtitle: Text(
                    '${discoveredDevices[index].device.address.toString()} RSSI:${discoveredDevices[index].rssi}',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  leading: Icon(Icons.bluetooth,
                      size: 25.0, color: Colors.lightBlueAccent),
                  trailing: DropdownButton(
                    //value: _value,
                    // hint: Text("Select item"),
                    value: dropDownMenuButtonValuesList[index],
                    items: dropdownMenuOptions,
                    onChanged: (String? s) {
                      setState(() {
                        dropDownMenuButtonValuesList[index] = s!;

                        if (s == list_items[0]) {
                          //This should be "Front"
                          print('bluetooth_settings: "Front" was selected');
                          frontDevice?.closeConnectionOnReselection(
                              discoveredDevices[index].device);
                          print(
                              'Front Bluetooth Device address set to: ${discoveredDevices[index].device.address}');
                          frontBluetoothDevice =
                              discoveredDevices[index].device.address;

                          print(
                              'Attempting to Connect to Front Device (${discoveredDevices[index].device.address})');
                          frontDevice = CreateBluetoothDevice(
                              deviceAddress:
                                  discoveredDevices[index].device.address,
                              deviceName: discoveredDevices[index].device.name);
                          frontDevice!.startConnection();
                        }
                        if (s == list_items[1]) {
                          //This should be "Back''
                          print('bluetooth_settings: "Back" was selected');
                          backDevice?.closeConnectionOnReselection(
                              discoveredDevices[index].device);
                          print(
                              'Back Bluetooth Device address set to: ${discoveredDevices[index].device.address}');
                          backBluetoothDevice =
                              discoveredDevices[index].device.address;
                          print(
                              'Attempting to Connect to Back Device (${discoveredDevices[index].device.address})');
                          backDevice = CreateBluetoothDevice(
                              deviceAddress:
                                  discoveredDevices[index].device.address,
                              deviceName: discoveredDevices[index].device.name);
                          backDevice!.startConnection();
                        }
                        if (s == list_items[2]) {
                          // This should be "Interior"
                          print('bluetooth_settings: "Interior" was selected');
                          // interiorDevice?.closeConnectionOnReselection(
                          //discoveredDevices[index].device);

                          //this should set up the bluetooth Interior Device to connect to the mac address
                          print(
                              'Interior BluetoothDevice address set to : ${discoveredDevices[index].device.address}');
                          //Setting Interior Bluetooth Type to the type selected
                          interiorBluetoothDeviceAddress =
                              discoveredDevices[index].device.address;
                          //Creating a socket to the bluetoothDevice
                          print(
                              'Attempting to Connect to Interior Device (${discoveredDevices[index].device.address})');
                          interiorDevice = CreateBluetoothDevice(
                              deviceAddress:
                                  discoveredDevices[index].device.address,
                              deviceName: discoveredDevices[index].device.name);
                          interiorDevice!.startConnection();
                        }
                        if (s == list_items[3]) {
                          print(
                              'bluetooth_settings: "Livewell-Fill" was selected');
                          print(
                              'bluetooth_settings: "Livewell-Fill" - checking if fillPump Device is null--> if not, close connection and start a new one with this device');
                          fillPump.device?.closeConnectionOnReselection(
                              discoveredDevices[index]
                                  .device); // if device isn't null --> close the connection and start this one
                          print(
                              'bluetooth_settings: "Livewell-Fill"---> CreateBluetoothDevice(Name ${discoveredDevices[index].device.name}, Address: ${discoveredDevices[index].device.address}');
                          fillPump.device = CreateBluetoothDevice(
                              deviceAddress:
                                  discoveredDevices[index].device.address,
                              deviceName: discoveredDevices[index].device.name);
                          print(
                              'bluetooth_settings: attempt to start Connection with the "Livewell-Fill" device');
                          fillPump.device!.startConnection();
                          // if device is not null startConnection

                        }
                        if (s == list_items[4]) {
                          print(
                              'bluetooth_settings: "Livewell-Empty" was selected');
                          print(
                              'bluetooth_settings: "Livewell-Empty" - checking if outPump Device is null--> if not, close connection and start a new one with this device');
                          outPump.device?.closeConnectionOnReselection(
                              discoveredDevices[index]
                                  .device); // if device isn't null --> close the connection and start this one
                          print(
                              'bluetooth_settings: "Livewell-Empty"---> CreateBluetoothDevice(Name ${discoveredDevices[index].device.name}, Address: ${discoveredDevices[index].device.address}');
                          outPump.device = CreateBluetoothDevice(
                              deviceAddress:
                                  discoveredDevices[index].device.address,
                              deviceName: discoveredDevices[index].device.name);
                          print(
                              'bluetooth_seetings: attempt to start Connection with the "Livewell-Empty" device');
                          outPump.device!
                              .startConnection(); // if device is not null startConnection
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
