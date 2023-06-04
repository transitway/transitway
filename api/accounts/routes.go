package accounts

import "github.com/gofiber/fiber/v2"

func Routes(app *fiber.App) {
  acc := app.Group("/accounts")

  onboarding(acc)
  balance(acc)
  settings(acc)
  payments(acc)
}