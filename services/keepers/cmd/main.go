package main

import (
	"fmt"
	"os"

	"github.com/berachain/offchain-sdk/cmd"
	app "github.com/infrared-dao/infrared-mono-repo/services/keepers/app"
	keepersconfig "github.com/infrared-dao/infrared-mono-repo/services/keepers/config"
)

func main() {
	if err := cmd.BuildBasicRootCmd[keepersconfig.Config](&app.KeeperApp{}).Execute(); err != nil {
		fmt.Fprintf(
			os.Stderr, "Whoops. There was an error while executing your app (%s)", err.Error(),
		)
		os.Exit(1)
	}
}
