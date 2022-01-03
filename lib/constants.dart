import 'package:bt_serial_stream_from_esp32/bluetooth_device.dart';
import 'package:flutter/material.dart';
import 'package:bt_serial_stream_from_esp32/screens/livewell_screen.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({required this.onPressed, required this.text});
  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 60.0,
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blueGrey),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.lightBlueAccent,
            fontWeight: FontWeight.w500,
            fontSize: 20.0),
      ),
    );
  }
}

//           LIVEWELLL PAGE CONSTANTS                   /////

class Timer {
  double countdownDuration;
  ValueNotifier<double> notifier;
  Timer({required this.countdownDuration, required this.notifier});
  bool stateActive = false;

  void startTimer(LivewellFunctionObject livewellFunctionObject) async {
    // check if the livewell you are working with has a counter that is already in progress
    if (livewellFunctionObject.onTimer.stateActive) {
      print(
          'LivewellFunction Object is set to onTimer with an stateActive=true');
      // if the livewellFunction is currently on or filling
      print(
          'Because LivewellfunctionObject onTimer was True- setting the livewellFunctionObject.stateActive to false');
      livewellFunctionObject.offTimer.stateActive =
          false; // if we are filling the state for the offTimer should be off

    } else {
      print('livewellFunctionObject offTimer was set to True');
      // the stateActive should be that the offTimer is true
      livewellFunctionObject.onTimer.stateActive = false; //
      print(
          'because the livewellFunctionObject offTimer was set to True- The onTimer is being set to false');
    }

    if (livewellFunctionObject.automaticSwitch) {
      print('livewellFunctionObject.automaticSwitch is ON');
      this.stateActive = true;
      print('set current timer to active state');
      while ((this.countdownDuration > 0) &&
          livewellFunctionObject.automaticSwitch) {
        await Future.delayed(Duration(seconds: 1), () {
          // if the stateActive was done on an onTimer-- turn that deviceON..
          if (livewellFunctionObject.onTimer.stateActive) {
            livewellFunctionObject.device?.sendDataOn();
          }
          //if the countdown is less than on for some reason, just turn off instead of going negative
          if (this.countdownDuration < 1) {
            this.countdownDuration = 0;
            this.notifier.value = this.countdownDuration;
          } else {
            //keep counting down
            this.countdownDuration--;
            print(
                'Current Livewell object countdown ${this.countdownDuration}');
            this.notifier.value = this.countdownDuration;
          }
        });
      }

      if (livewellFunctionObject.onTimer.stateActive &&
          livewellFunctionObject.onTimer.countdownDuration == 0) {
        print(
            'livewell function object was on- but has ran out of time-- turning its state to false');
        // if the onTimer is in an activeState and CountdownDuration is 0. Start off timer
        livewellFunctionObject.device?.sendDataOff();
        livewellFunctionObject.onTimer.stateActive =
            false; // turning off current stateActive
        print(
            'Livewell Function was previously in in an on-state but will now go into an off state');
        print(
            'Ensure the offTimer value is reset to something other than zero--> livewellFunctionObject.offTimer.countdownDuration= livewellFunctionObject.offMaxSliderValue');
        livewellFunctionObject.offTimer.countdownDuration =
            livewellFunctionObject.offSliderMax;
        print(
            'LivewellFunctionObject onTimer was at zero- but now being reset for next time--> livewellFunctionObject.onTimer.countdownDuration=livewellFunctionObject.offMaxSliderValue');
        livewellFunctionObject.onTimer.countdownDuration =
            livewellFunctionObject.onSliderMax;
        livewellFunctionObject.offTimer.startTimer(livewellFunctionObject);
        print(
            'LivewellFunctionObject.offTimer should start to count down --> function has restarted');
      } else {
        print(
            'Either livewellFunctionTimer.onTimer.stateActive==False OR livewellFunctionObject.onTimer.countDownDuration==0');

        this.stateActive = false;
        livewellFunctionObject.onTimer.startTimer(
            livewellFunctionObject); // --> puts itself as the object and turns the other function on (delay or pumping on)
      }

      // after the pump has ran it's cycle - turn  on the delay or vice versa
    }
  }
}

LivewellFunctionObject fillPump = LivewellFunctionObject(
    automaticSwitch: false,
    manualSwitch: false,
    onTimer: Timer(countdownDuration: 240, notifier: ValueNotifier(240)),
    offTimer: Timer(countdownDuration: 1800, notifier: ValueNotifier(1800)));

LivewellFunctionObject outPump = LivewellFunctionObject(
    automaticSwitch: false,
    manualSwitch: false,
    onTimer: Timer(countdownDuration: 30, notifier: ValueNotifier(30)),
    offTimer: Timer(countdownDuration: 1200, notifier: ValueNotifier(1200)));

class LivewellFunctionObject {
  bool automaticSwitch;
  bool manualSwitch;
  Timer onTimer;
  Timer offTimer;
  CreateBluetoothDevice? device;
  late double onSliderMax = onTimer.countdownDuration;
  late double offSliderMax = offTimer.countdownDuration;

  LivewellFunctionObject({
    this.automaticSwitch = false,
    this.manualSwitch = false,
    required this.onTimer,
    required this.offTimer,
  });

  //if in automatic mode --> manual mode is automatically false and disabled --(Completed)
  // if in manual mode--> sets to false automatically-- (Completed)
  // if countdown for off is active --> countdown for on is 0(and notifier is zero)
  // if countdown for on is active-->countdown for off is 0 (and notifier is zero)
  // if on-countdown is active BluetoothDevice is ON
  // if off-countdown is active-- BluetoothDevice is off

}
