package database

import (
	"log"
	"os"
	"product-service/models"

	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	var err error
	dsn := os.Getenv("DATABASE_URL")

	if dsn != "" {
		// Use Postgres (Heroku)
		DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	} else {
		// Use SQLite (Local)
		dbPath := os.Getenv("DB_PATH")
		if dbPath == "" {
			dbPath = "product.db"
		}
		DB, err = gorm.Open(sqlite.Open(dbPath), &gorm.Config{})
	}

	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	DB.AutoMigrate(&models.Item{}, &models.Category{}, &models.ItemImage{}, &models.Bid{})
}
