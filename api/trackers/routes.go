package trackers

import (
	"api/db"
	"fmt"

	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
)

func Routes(app *fiber.App) {

  trackers := app.Group("trackers")

  trackers.Post("", func (c *fiber.Ctx) error {
    id := c.Query("id")
    longitude := c.Query("longitude")
    latitude := c.Query("latitude")

    long := fmt.Sprintf("tracker:%v:longitude", id)
    lat := fmt.Sprintf("tracker:%v:latitude", id)

    db.Set(long, longitude)
    db.Set(lat, latitude)

    return c.JSON("ok")
  })

  trackers.Get("", func (c *fiber.Ctx) error {
    id := c.Query("id")

    long := fmt.Sprintf("tracker:%v:longitude", id)
    lat := fmt.Sprintf("tracker:%v:latitude", id)
    
    longitude, _ := db.Get(long)
    latitude, _ := db.Get(lat)

    return c.JSON(bson.M {
      "longitude": longitude,
      "latitude": latitude,
    })
  })
}