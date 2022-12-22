/* 
 *  Bluetooh Basic: LED ON OFF - Avishkar
 *  Coder - Mayoogh Girish
 *  Website - http://bit.do/Avishkar
 *  Download the App : 
 *  This program lets you to control a LED on pin 13 of arduino using a bluetooth module
 */
#include <SoftwareSerial.h>
#include <string.h>

#define rxPin 10
#define txPin 11
#define LED 13

SoftwareSerial HM19(rxPin, txPin); 
char Incoming_value1 = -1;                //Variable for storing Incoming_value
int count = 0;
bool isCounting = false;

void setup() 
{
  HM19.begin(9600);         //Sets the data rate in bits per second (baud) for serial data transmission
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
}

void loop()
{
  if(Serial.available()){
    HM19.write(Serial.read());
  }
  
  if(HM19.available())  
  {
    Incoming_value1 = HM19.read();      //Read the incoming data and store it into variable Incoming_value
    Serial.println(Incoming_value1);        //Print Value of Incoming_value in Serial monitor
    
    if (Incoming_value1 == '1'){
      digitalWrite(LED, HIGH);
      isCounting = true;
    }      
    else if(Incoming_value1 == '0'){
      digitalWrite(LED, LOW);
      isCounting = false;
      count = 0;
    }     
  }

  if (isCounting){
    if (count < 10000){
      count += 1;      
    } else {
      count = 0;      
    }
    char my_str[5];
    itoa(count, my_str, 10);
    HM19.write(my_str);
    Serial.println(my_str);
  }  
  
  delay(1000);
}   
