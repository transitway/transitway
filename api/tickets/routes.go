package tickets

import (
	"api/models"
	"api/utils"
	"encoding/json"
	"fmt"

	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
)

func Routes(app *fiber.App) {
  tickets := app.Group("/tickets")

  tickets.Get("/types", models.AccountMiddleware, func (c *fiber.Ctx) error {
    ticketTypes, err := models.GetTicketTypes("ploiesti")
    if err != nil {
      return utils.MessageError(c, "Nu s-au putut gasi tipurile de bilete")
    }

    return c.JSON(ticketTypes)
  })


  tickets.Post("/buy", models.AccountMiddleware, func (c *fiber.Ctx) error {
    var body map[string][]string
    json.Unmarshal(c.Body(), &body)

    typeID := c.Query("typeID")
    ticketType, err := models.GetTicketType(typeID)
    if err != nil {
      return utils.MessageError(c, "???")
    }

    var ticket models.Ticket

    ticket.Name = ticketType.Name
    ticket.Category = ticketType.Category
    ticket.City = ticketType.City
    ticket.Lines = body["lines"][0:ticketType.NoLines]

    var account models.Account 
    utils.GetLocals(c, "account", &account)

    ticket.AccountID = account.ID

    err = ticket.Create(ticketType.Expiry)
    if err != nil {
      return utils.MessageError(c, "Nu s-a putut cumpara bilet")
    }

    balance, err := models.ChargeBalance(account.ID, ticketType.Fare)
    if err != nil {
      return utils.MessageError(c, "eroare")
    }

    return c.JSON(
      bson.M {
        "ticket": ticket,
        "balance": balance,
      },
    )
  })

  tickets.Get("", models.AccountMiddleware, func (c *fiber.Ctx) error {
    var accountID string = fmt.Sprintf("%v", c.Locals("id"))
    tickets, err := models.GetTickets(accountID)
    if err != nil {
      return utils.MessageError(c, "Nu s-au putut gasi bilete")
    }

    return c.JSON(tickets)
  })
}