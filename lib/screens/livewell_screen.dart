import 'dart:async';

import 'package:flutter/material.dart';
import 'light_screen.dart';
import 'package:bt_serial_stream_from_esp32/constants.dart';
import 'package:bt_serial_stream_from_esp32/globals.dart';
import 'package:bt_serial_stream_from_esp32/screens/bluetooth_settings.dart';

class LivewellScreen extends StatefulWidget {
  static const String id = 'livewell_screen';

  @override
  _LivewellScreenState createState() => _LivewellScreenState();
}

class _LivewellScreenState extends State<LivewellScreen> {
  String value = 'OFF';
  String valueOn = 'ON';
  String valueOff = 'OFF';

  double _fillSliderValue = fillPump.onSliderMax;
  double _delaySliderValue = fillPump.offSliderMax;
  double _outSliderValue = outPump.onSliderMax;
  double _outDelaySliderValue = outPump.offSliderMax;
  String startStopText = 'START';
  // bool automaticSwitch = false;

  String changeValue(String currentValue) {
    if (currentValue == 'ON') {
      return valueOff;
    } else {
      return valueOn;
    }
  }

  void changeText(String currentText) {
    if (currentText == 'START') {
      startStopText = 'STOP';
    } else {
      startStopText = 'START';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('Livewell Controller',
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
      body: SingleChildScrollView(
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Automatic Control:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: Colors.lightBlueAccent)),
                  Switch(
                    value: fillPump.automaticSwitch,
                    onChanged: (value) {
                      fillPump.automaticSwitch = value;
                      if (fillPump.automaticSwitch) {
                        // if the pump was on- turn it off
                        fillPump.device
                            ?.sendDataOff(); // so manual can't overrise
                        // disable the manual switch while in auto-mode
                        fillPump.manualSwitch =
                            false; // Ensure the pump doesn't kick on from the if the Manual Switch is left in the on position when pulled null
                        //
                        // reset teh local notifier value to the user-set values
                        fillPump.onTimer.notifier.value = fillPump.onSliderMax;
                        fillPump.offTimer.notifier.value =
                            fillPump.offSliderMax;
                        // go ahead and start the auto-mode, no need to adjust sliders to get the timer to start

                        fillPump.onTimer.startTimer(fillPump);
                      } else {
                        // this means the value of the fillPump.automaticSwitch turned false
                        fillPump.onTimer.countdownDuration = 0;
                        fillPump.offTimer.countdownDuration = 0;
                        fillPump.onTimer.notifier.value =
                            fillPump.onTimer.countdownDuration;
                        fillPump.offTimer.notifier.value =
                            fillPump.offTimer.countdownDuration;
                        fillPump.device?.sendDataOff();
                      }

                      setState(() {});
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Manual Control:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.lightBlueAccent)),
                      Switch(
                        value: fillPump.manualSwitch,
                        onChanged: fillPump
                                .automaticSwitch // if automaticSwitch is on--> the Manual Switch is NULL
                            ? null
                            : (value) {
                                fillPump.manualSwitch = value;
                                if (fillPump.manualSwitch) {
                                  print(
                                      'Fill Pump has sent manual signal to turn pump on');
                                  fillPump.device?.sendDataOn();
                                } else {
                                  print(
                                      'Fill Pump has sent manual signal to turn pump off');
                                  fillPump.device?.sendDataOff();
                                } // this should Turn the pump on or off --> true false
                                setState(() {});
                              },
                      ),
                    ],
                  ),
                ],
              ),
              Text('Livewell Fill Pump',
                  style:
                      TextStyle(fontSize: 40.0, fontWeight: FontWeight.w200)),
              Text(
                  'Fill Time: ${_fillSliderValue.toStringAsFixed(1)} second(s)',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: Colors.lightBlueAccent)),
              Slider(
                  min: 0,
                  max: 3600,
                  divisions: 3600,
                  value: _fillSliderValue,
                  label: "Time: ${_fillSliderValue.toStringAsFixed(1)}",
                  onChangeStart: (double value) {
                    fillPump.onTimer.countdownDuration = 0;
                    fillPump.onTimer.notifier.value =
                        fillPump.onTimer.countdownDuration;
                  },
                  onChanged: fillPump.automaticSwitch
                      ? null
                      : (double value) {
                          _fillSliderValue = value;
                          setState(() {});
                          print(
                              "fill Slider Value : ${_fillSliderValue.toStringAsFixed(1)}");
                        },
                  onChangeEnd: (double newValue) {
                    print('ON-CHANGED END $newValue');
                    fillPump.onTimer.countdownDuration = newValue;
                    //fillPump.onTimer.startTimer(fillPump);
                    fillPump.onSliderMax = _fillSliderValue;
                  }),
              ValueListenableBuilder<double>(
                builder: (BuildContext context, double value, Widget? child) {
                  return Text('${fillPump.onTimer.notifier.value}',
                      style: TextStyle(fontSize: 20));
                },
                child: Text('${fillPump.onTimer.notifier.value}'),
                valueListenable: fillPump.onTimer.notifier,
              ),
              Text(
                  'Delay Time: ${_delaySliderValue.toStringAsFixed(2)} second(s)',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: Colors.lightBlueAccent)),
              Slider(
                  min: 0,
                  max: 3600,
                  divisions: 3600,
                  value: _delaySliderValue,
                  label: "Time: ${_delaySliderValue.toStringAsFixed(1)}",
                  onChangeStart: (double value) {
                    fillPump.offTimer.countdownDuration = 0;
                    fillPump.offTimer.notifier.value =
                        outPump.offTimer.countdownDuration;
                  },
                  onChanged: fillPump.automaticSwitch
                      ? null
                      : (double value) {
                          _delaySliderValue = value;
                          setState(() {});
                          print(
                              "Delay Slider Value : ${_delaySliderValue.toStringAsFixed(1)}");
                        },
                  onChangeEnd: (double newValue) {
                    print('ON-CHANGED END $newValue');
                    fillPump.offTimer.countdownDuration =
                        newValue; // changing offTimer Value
                    fillPump.offTimer.notifier.value =
                        fillPump.offTimer.countdownDuration;
                    //fillPump.offTimer.startTimer(
                    //   fillPump); //Starting the offTimer-- as long as automaticSwitch is turned on
                    fillPump.offSliderMax =
                        _delaySliderValue; // remembering the slider value for if user navigates away from the page and back to it
                  }),
              ValueListenableBuilder<double>(
                builder: (BuildContext context, double value, Widget? child) {
                  return Text('${fillPump.offTimer.notifier.value}',
                      style: TextStyle(fontSize: 20));
                },
                child: Text('${fillPump.offTimer.notifier.value}'),
                valueListenable: fillPump.offTimer.notifier,
              ),
            ]),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Automatic Control:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: Colors.lightBlueAccent)),
                  Switch(
                    value: outPump.automaticSwitch,
                    onChanged: (value) {
                      outPump.automaticSwitch = value;
                      if (outPump.automaticSwitch) {
                        // if outpump for was on- we are going to make sure its off
                        outPump.device
                            ?.sendDataOff(); // so manual can't overrise
                        // we are going to disable the manual switch--> and make sure it's false
                        outPump.manualSwitch =
                            false; // Ensure the pump doesn't kick on from the if the Manual Switch is left in the on position when pulled null
                        //updating the notifiers to the current user= set values
                        outPump.onTimer.notifier.value = outPump.onSliderMax;
                        outPump.offTimer.notifier.value = outPump.offSliderMax;
                        // starting the pump
                        outPump.onTimer.startTimer(outPump);
                      } else {
                        // this means the value of the fillPump.automaticSwitch turned false
                        // turn the coundownDuration to 0
                        outPump.onTimer.countdownDuration = 0;
                        outPump.offTimer.countdownDuration = 0;
                        // make sure the notifiers match the duration
                        outPump.onTimer.notifier.value =
                            outPump.onTimer.countdownDuration;
                        outPump.offTimer.notifier.value =
                            outPump.offTimer.countdownDuration;
                        outPump.device?.sendDataOff();
                      }

                      setState(() {});
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Manual Control:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.lightBlueAccent)),
                      Switch(
                        value: outPump.manualSwitch,
                        onChanged: outPump
                                .automaticSwitch // if automaticSwitch is on--> the Manual Switch is NULL
                            ? null
                            : (value) {
                                outPump.manualSwitch = value;
                                if (outPump.manualSwitch) {
                                  print(
                                      'Out-Pump was sent signal to turn pump on');
                                  outPump.device?.sendDataOn();
                                } else {
                                  print(
                                      'Out-Pump was sent signal to turn pump off');
                                  outPump.device?.sendDataOff();
                                } // this should Turn the pump on or off --> true false
                                setState(() {});
                              },
                      ),
                    ],
                  ),
                ],
              ),
              Text('Livewell Empty Pump',
                  style:
                      TextStyle(fontSize: 40.0, fontWeight: FontWeight.w200)),
              Text('On Time: ${_outSliderValue.toStringAsFixed(1)} second(s)',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: Colors.lightBlueAccent)),
              Slider(
                  min: 0,
                  max: 3600,
                  divisions: 3600,
                  value: _outSliderValue,
                  label: "Time: ${_outSliderValue.toStringAsFixed(1)}",
                  onChangeStart: (double value) {
                    outPump.onTimer.countdownDuration = 0;
                    outPump.onTimer.notifier.value =
                        outPump.onTimer.countdownDuration;
                  },
                  onChanged: outPump.automaticSwitch
                      ? null
                      : (double value) {
                          _outSliderValue = value;
                          setState(() {});
                          print(
                              "fill Slider Value : ${_outSliderValue.toStringAsFixed(1)}");
                        },
                  onChangeEnd: (double newValue) {
                    print('ON-CHANGED END--> Empty Pump ON $newValue');
                    outPump.onTimer.countdownDuration = newValue;
                    //outPump.onTimer.startTimer(outPump);
                    outPump.onSliderMax = _outSliderValue;
                  }),
              ValueListenableBuilder<double>(
                builder: (BuildContext context, double value, Widget? child) {
                  return Text('${outPump.onTimer.notifier.value}',
                      style: TextStyle(fontSize: 20));
                },
                child: Text('${outPump.onTimer.notifier.value}'),
                valueListenable: outPump.onTimer.notifier,
              ),
              Text(
                  'Delay Time: ${_outDelaySliderValue.toStringAsFixed(2)} second(s)',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: Colors.lightBlueAccent)),
              Slider(
                  min: 0,
                  max: 3600,
                  divisions: 3600,
                  value: _outDelaySliderValue,
                  label: "Time: ${_outDelaySliderValue.toStringAsFixed(1)}",
                  onChangeStart: (double value) {
                    outPump.offTimer.countdownDuration = 0;
                    outPump.offTimer.notifier.value =
                        outPump.offTimer.countdownDuration;
                  },
                  onChanged: outPump.automaticSwitch
                      ? null
                      : (double value) {
                          _outDelaySliderValue = value;
                          setState(() {});
                          print(
                              "Delay Slider Value : ${_outDelaySliderValue.toStringAsFixed(1)}");
                        },
                  onChangeEnd: (double newValue) {
                    print('ON-CHANGED END $newValue');
                    outPump.offTimer.countdownDuration =
                        newValue; // changing offTimer Value
                    outPump.offTimer.notifier.value =
                        fillPump.offTimer.countdownDuration;
                    //outPump.offTimer.startTimer(
                    // outPump); //Starting the offTimer-- as long as automaticSwitch is turned on
                    outPump.offSliderMax =
                        _outDelaySliderValue; // remembering the slider value for if user navigates away from the page and back to it
                  }),
              ValueListenableBuilder<double>(
                builder: (BuildContext context, double value, Widget? child) {
                  return Text(
                      '${outPump.offTimer.notifier.value.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 20));
                },
                child: Text(
                    '${outPump.offTimer.notifier.value.toStringAsFixed(1)}'),
                valueListenable: outPump.offTimer.notifier,
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
