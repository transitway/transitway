# transitway
The Transitway API is developed using the Go programming language and the Fiber framework, which is a fast and easy-to-use alternative for web services development. This combination allows us to build an efficient application.

For data storage, we use MongoDB, a flexible and scalable database. Interaction with MongoDB is done through the mongo-go-driver library, which gives us all the tools we need to work with the database. To improve performance and reduce access time to frequently used data, we use Redis, an in-memory caching system. Redis helps us store authentication codes quickly and efficiently, ensuring a smooth user experience.

For authenticating users and sending authentication codes via SMS, we rely on the Twilio service and the twilio-go library. Twilio provides us with a set of tools to manage user interaction via SMS messages. For token generation and authentication, we use the sjwt library, which provides us with all the necessary functionality to manipulate and verify JSON tokens.

Securing sensitive data, such as user passwords, is a priority for us. That's why we use the bcrypt hashing algorithm to protect them. Passcodes are stored in Redis as encrypted hashes, using Go's standard crypto library. For converting data to JSON and vice versa, we rely on the encoding/json package in the Go standard library, which facilitates communication between client and server.

As for the payment system, we integrate the Stripe service, a popular and secure online payment platform. For interaction with Stripe, we use the stripe-go library, which provides us with secure and standardized methods for managing transactions and the in-app payment process. This ensures a reliable and secure payment experience for users.
