package main

import (
	"api/accounts"
	"api/db"
	"api/env"
	"api/tickets"
	"api/trackers"

	"github.com/go-redis/redis/v8"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/stripe/stripe-go/v74"
)

var RedisOptions *redis.Options = &redis.Options {
  Addr: "127.0.0.1:6379",
  Password: "",
  DB: 0,
}

func main() {
  app := fiber.New()

  stripe.Key = env.StripeKey

  app.Use(cors.New(cors.Config{
    AllowOrigins: "*",
  }))

  db.InitDB()
  db.InitCache(RedisOptions)

  app.Get("/test", func (c *fiber.Ctx) error {
    return c.SendString("it's working")
  })

  accounts.Routes(app)
  tickets.Routes(app)
  trackers.Routes(app)

  app.Listen(":4200")
}