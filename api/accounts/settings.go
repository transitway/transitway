package accounts

import (
	"api/models"
	"api/utils"
	"encoding/json"

	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
)

func settings(acc fiber.Router) {
  settings := acc.Group("/settings")

  settings.Post("/address/:typeOf", models.AccountMiddleware, func (c *fiber.Ctx) error {
    var address models.AccountAddress
    json.Unmarshal(c.Body(), &address)
    typeOf := c.Params("typeOf")

    account := models.Account {}
    utils.GetLocals(c, "account", &account)
    
    err := account.ModifyAccountAddress(address, typeOf)
    if err != nil {
      return utils.MessageError(c, "Nu se poate adauga")
    }

    token := account.GenAccountToken()

    return c.JSON(
      bson.M {
        "account": account,
        "token": token,
      },
    )
  })
}