App Programs: Information Relay

This project simulates a communication method for a medical device to wirelessly
submit data that is reviewed by relevant personnel. There are 3 applications to
replicate each components: a medical device, patient's iPhone, and access controlled
personnel.

Embedded system using Arduino with a Bluetooth component is needed to replicate a
medical device. A program under 'Bluetooth.ino' is opened using Arduino Integrated 
Development Environment (IDE) and is uploaded to an Ardiuno microcontroller. An LED 
is not required, but provides a visual indication of commmunication between the 
microcontroller and a patient's iPhone. No other action needs to be performed for this
part.


Xcode is an IDE from Apple and is free, but needs to be used on a Mac. Xcode is used
to run Swift language and is able to simulate various iOS and iPhone device. InfoRelay
application simulates the patient's iPhone device communicating with the microcontroller
and MQTT broker. Open 'InfoRelay.xcodeproj' to run the application on Xcode. This application
needs Bluetooth connection so an iPhone device with a minimum of iOS version 15.5 needs to
be connected to a Mac. The connected iPhone needs to be selected on Xcode before the application 
is runned. Finally, open 'MQTTClient.xcodeproj' to simulate a relevant personnel receiving the data 
for review. This application can be ran on the Xcode simulator by selecting any iPhone device
on Xcode. An iPhone emulator with the selected iPhone version will open, and the application
will run on the emulator. 
