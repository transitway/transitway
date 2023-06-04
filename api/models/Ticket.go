package models

import (
	"api/db"
	"api/utils"
	"time"

	"go.mongodb.org/mongo-driver/bson"
)

type Ticket struct {
  ID string `bson:"id" json:"id"`
  AccountID string `bson:"accountID" json:"accountID"`
  Name string `bson:"name" json:"name"`
  Category string `bson:"category" json:"category"`
  Lines []string `bson:"lines" json:"lines"`
  City string `bson:"city" json:"city"`
  ExpiresAt time.Time `bson:"expiresAt" json:"expiresAt"`
  CreatedAt time.Time `bson:"createdAt" json:"createdAt"`
}

func GetTickets(accountID string) ([]Ticket, error) {
  cursor, err := db.Tickets.Find(ctx, bson.M{
    "accountID": accountID,
  })

  if err != nil {
    return []Ticket {}, err
  }

  tickets := []Ticket {}

  err = cursor.All(ctx, &tickets)
  if len(tickets) == 0 {
    tickets = []Ticket {}
  }

  return tickets, err
}

func (ticket *Ticket) Create(expiry string) error {
  ticket.ID = utils.GenID(9)

  loc, _ := time.LoadLocation("Europe/Bucharest")
  ticket.CreatedAt = time.Now().In(loc)
  switch expiry {
  case "1h":
    ticket.ExpiresAt = ticket.CreatedAt.Add(time.Hour)
  case "1d":
    ticket.ExpiresAt = ticket.CreatedAt.AddDate(0, 0, 1)
  case "1m":
    ticket.ExpiresAt = ticket.CreatedAt.AddDate(0, 1, 1)
  }

  _, err := db.Tickets.InsertOne(ctx, ticket)
  return err
}