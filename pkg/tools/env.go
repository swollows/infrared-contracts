package tools

import (
	"os"

	"github.com/subosito/gotenv"
)

// GetEnv returns the value of the environment variable key if it exists, otherwise it returns the default value.
func GetEnv(key, defaultValue string) string {
	// Load the envrionment variables from the .env file.
	if err := gotenv.Load(); err != nil {
		panic(err) // fine to panic here since app will not be able to run without env vars.
	}

	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}
