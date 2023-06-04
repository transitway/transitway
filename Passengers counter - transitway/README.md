The code implements a passenger counting system using an IR sensor and sends the information to a web server using HTTP POST requests.

At the beginning of the code, initialization of serial communication with the SIM800L module is performed and the pin for the IR sensor is configured as an input pin with pull-up resistor enabled.

In the loop() function, the status of the IR sensor is checked. If the sensor detects a passenger entering the zone (IR pin status becomes LOW), the number of incoming passengers is incremented and the sendPassengerNumber() function is called to send the information to the server.

If the sensor detects a passenger leaving the area (status of pin 3 becomes LOW) and there are more passengers entering than leaving, the number of passengers leaving is incremented and the sendPassengersNumber() function is called to send the information to the server.

The sendPassengersNumber() function constructs the HTTP POST request, including the number of passengers who entered and those who left in the required data format. Then, via the SIM800L module, initialize the HTTP service, send the POST request to the server and wait for a response. After successful submission, the HTTP service is terminated and the GPRS connection is closed.
