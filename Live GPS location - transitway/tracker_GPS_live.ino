#include <WiFi.h>
#include <HTTPClient.h>
#include <TinyGPS++.h>

// Replace with your network credentials
const char* ssid = "steven";
const char* password = "stevensun1";

// Replace with your API endpoint
const char* apiEndpoint = "https://api.transitway.online/trackers";

// GPS module connections
static const int RXPin = 13; // GPIO13 on ESP32 (RX from GPS module)
static const int TXPin = 12; // GPIO12 on ESP32 (TX to GPS module)
static const uint32_t GPSBaud = 9600;

// Create a TinyGPS++ object
TinyGPSPlus gps;

// Create a HardwareSerial object to communicate with the GPS module
HardwareSerial gpsSerial(1); // Use UART 1

void setup()
{
  Serial.begin(115200);
  gpsSerial.begin(GPSBaud, SERIAL_8N1, RXPin, TXPin);

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("Connected to WiFi!");
}

void loop()
{
  // Check GPS data
  while (gpsSerial.available() > 0) {
    if (gps.encode(gpsSerial.read())) {
      // Get GPS data
      double latitude = gps.location.lat();
      double longitude = gps.location.lng();

      // Create API endpoint URL
      String apiURL = apiEndpoint;
      apiURL += "?id=1";
      apiURL += "&longitude=" + String(longitude, 6);
      apiURL += "&latitude=" + String(latitude, 6);

      // Send HTTP POST request
      HTTPClient http;
      http.begin(apiURL);
      int httpResponseCode = http.POST("");

      // Check HTTP response
      if (httpResponseCode > 0) {
        Serial.print("HTTP Response code: ");
        Serial.println(httpResponseCode);
      } else {
        Serial.println("Error sending HTTP POST request");
      }

      http.end();

      delay(1000); // Wait for 1 second before sending the next request
    }
  }
}
