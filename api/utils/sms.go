package utils

import (
	twilio "github.com/twilio/twilio-go"
	openapi "github.com/twilio/twilio-go/rest/api/v2010"

	"api/env"
)

func SendSMS(to string, code string) (error) {
  client := twilio.NewRestClientWithParams(
    twilio.ClientParams {
      Username: env.TwilioUsername,
      Password: env.TwilioPassword,
    },
  )

  params := &openapi.CreateMessageParams {}
  params.SetTo(to)
  params.SetFrom(env.TwilioNumber)
  params.SetBody(code + " este codul dumneavoastră de autentificare pentru transitway.")

  _, err := client.Api.CreateMessage(params)
  return err;
}