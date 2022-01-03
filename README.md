# bt_serial_stream_from_esp32

First attempt to write a flutter application that connects to an ESP32 and is able to control outputs on command from Mobile application. 

This project is able to connect to 5 different ESP32s and keep communication with all concurrently to automate electronics on a boat. 

== Current issues==
- Livewell Timers need to be re-written in better form
- Depending on Device used - there may be UI overflow issues on the Livewell controls screen 

==Future Enhancements?== 
- Easily could make this iOS as well as android
- ESP32s have immense amounts of I/Os with very little work I probably could have done all these functions from 1 ESP instead of 5
- ESP32 code is the same for every instance- i.e operating the same I/O pin
- Had thoughts of adding Dissolved Oxygen Meters connected to the ESP32 to give Feedback to the App as to the 'healthy-ness' of the water
- Had thoughts of adding Temperature probe to ESP32 to give feedback to the user over the app of temperature of the water
- Build models to integrate Automatic Livewell controls based on Dissolved Oxygen/Temperature. Such that the user can set parameters as to when to automatically empty the livewell and refill. (Example- When the temperature of the livewell water differs from the temperature of the lake water by >10degrees- empty and refill the livewell when boat speed >3mph etc).

Code for the ESP32 needs to be added to this project. 


## Light Button UI
![image](https://user-images.githubusercontent.com/46823960/147960665-39205bb1-49af-4db9-9307-51fc75942662.png)

## Livewell Control Ui

![image](https://user-images.githubusercontent.com/46823960/147960777-fe5acf8b-078e-4b5b-bec6-38f4db799b59.png)
## Bluetooth Device Discover Ui
![image](https://user-images.githubusercontent.com/46823960/147960742-696b7957-24fb-4af7-8191-66ea02d9929a.png)
