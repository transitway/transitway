package models

import (
	"api/db"
	"api/env"
	"api/utils"
	"fmt"
	"strings"
	"time"

	sj "github.com/brianvoe/sjwt"
	"github.com/gofiber/fiber/v2"
	"github.com/stripe/stripe-go/v74"
	"github.com/stripe/stripe-go/v74/customer"
	"go.mongodb.org/mongo-driver/bson"
)

type AccountAddress struct {
  Street string `bson:"street" json:"street"`
  Number string `bson:"number" json:"number"`
  Longitude float64 `bson:"longitude" json:"longitude"`
  Latitude float64 `bson:"latitude" json:"latitude"`
}

type Account struct {
  ID string `bson:"id" json:"id"`
  Phone string `bson:"phone" json:"phone"`
  FirstName string `bson:"firstName" json:"firstName"`
  LastName string `bson:"lastName" json:"lastName"`
  StripeCustomerID string `bson:"stripeCustomerID" json:"stripeCustomerID"`
  HomeAddress AccountAddress `bson:"homeAddress" json:"homeAddress"`
  WorkAddress AccountAddress `bson:"workAddress" json:"workAddress"`
}

func (account Account) GenAccountToken() string {
  claims, _ := sj.ToClaims(account)
  claims.SetExpiresAt(time.Now().Add(365 * 24 * time.Hour)) 
  // 1 year = 365 days * 24 hours in a day

  token := claims.Generate(env.JWTKey)
  return token 
}

func ParseAccountToken(token string) (Account, error) {
  hasVerified := sj.Verify(token, env.JWTKey)

  if !hasVerified {
    return Account {}, nil
  }

  claims, _ := sj.Parse(token)
  err := claims.Validate()
  account := Account {}
  claims.ToStruct(&account)

  return account, err
}

func AccountMiddleware(c *fiber.Ctx) error {
  var token string

  authHeader := c.Get("Authorization")

  if string(authHeader) != "" && strings.HasPrefix(string(authHeader), "Bearer") {
    token = strings.Fields(string(authHeader))[1]

    account, err := ParseAccountToken(token)
    if err != nil {
      return utils.MessageError(c, "A aparut o eroare")
    }

    c.Locals("id", account.ID)
    utils.SetLocals(c, "account", account)
  }

  if (token == "") {
    return utils.MessageError(c, "no token")
  }

  return c.Next()
}

func (account *Account) Create() error {
  // generating ID
  account.ID = utils.GenID(6)

  // creating balance
  balance := Balance {
    ID: account.ID,
    Value: 0.0,
  }
  balance.Create()

  // creating account
  _, err := db.Accounts.InsertOne(ctx, account)

  return err
}

func (account *Account) CreateStripeCustomer() error {
  fullName := account.LastName + " " + account.FirstName

  // creating a stripe account
  params := &stripe.CustomerParams {
    Phone: &account.Phone,
    Name: &fullName,
  }
  c, err := customer.New(params)

  if err != nil {
    return err
  }

  account.StripeCustomerID = c.ID
  return nil
}

func UpdateAccount(id string, updates interface {}) error {
  _, err := db.Accounts.UpdateOne(
    ctx,
    bson.M{"id": id},
    bson.M{
      "$set": updates,
    },
  )

  return err
}

func GetAccount(query interface {}) (Account, error) {
  var account Account

  err := db.Accounts.FindOne(
    ctx,
    query,
  ).Decode(&account)
  
  return account, err
}

func CheckAccount(phone string) (bool, Account) {
  // var exists bool
  var account Account

  err := db.Accounts.FindOne(
    ctx, bson.M {
      "phone": phone,
    },
  ).Decode(&account)

  if err != nil {
    return false, Account {} 
  } else {
    return true, account
  }
}

func (account *Account) ModifyAccountAddress(address AccountAddress, typeOf string) error {
  typeOfAddress := typeOf + "Address"
  fmt.Println(typeOfAddress)
  err := UpdateAccount(
    account.ID, 
    bson.M {
      typeOfAddress: address,
    },
  )

  if typeOf == "home" {
    account.HomeAddress = address
  } else if (typeOf == "work") {
    account.WorkAddress = address
  }

  return err
}