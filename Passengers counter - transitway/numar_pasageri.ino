#include <SoftwareSerial.h>

SoftwareSerial sim800l(10, 11); // Pinii RX, TX pentru modulul SIM800L
const int irSensorPin = 2; // Senzorul IR conectat la pinul digital 2
int pasageriIntrati = 0;
int pasageriPlecati = 0;

void setup() {
Serial.begin(115200);
sim800l.begin(9600); // Inițializarea modulului SIM800L
pinMode(irSensorPin, INPUT_PULLUP);
}

void loop() {
if (digitalRead(irSensorPin) == LOW) {
pasageriIntrati++;
trimiteNumarPasageri(); // Trimite numărul de pasageri la server
delay(500); // Ajustați întârzierea după nevoie
} else if (digitalRead(3) == 0 && pasageriIntrati > pasageriPlecati) {
pasageriPlecati++;
trimiteNumarPasageri(); // Trimite numărul de pasageri la server
delay(500); // Ajustați întârzierea după nevoie
}
}

void trimiteNumarPasageri() {
  String data = "intrati=" + String(pasageriIntrati) + "&plecati=" + String(pasageriPlecati);
  String postData = "POST /pasageripost HTTP/1.1\r\n";
  postData += "Host: api.transitway.tech\r\n";
  postData += "Content-Type: application/x-www-form-urlencoded\r\n";
  postData += "Content-Length: " + String(data.length()) + "\r\n";
  postData += "\r\n";
  postData += data;
  postData += "\r\n";

  sim800l.println("AT+SAPBR=1,1");
  delay(2000);
  sim800l.println("AT+HTTPINIT");
  delay(2000);
  sim800l.println("AT+HTTPPARA=\"URL\",\"https://api.transitway.tech/pasageripost\"");
  delay(2000);
  sim800l.println("AT+HTTPPARA=\"CONTENT\",\"application/x-www-form-urlencoded\"");
  delay(2000);
  sim800l.println("AT+HTTPDATA=" + String(postData.length()) + ",10000");
  delay(2000);
  sim800l.print(postData);
  delay(2000);
  sim800l.println("AT+HTTPACTION=1");
  delay(5000);
  sim800l.println("AT+HTTPTERM");
  delay(2000);
  sim800l.println("AT+SAPBR=0,1");
  delay(2000);
}



//Codul a fost realizat pentru transitway
