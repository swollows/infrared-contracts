package main

import (
	"fmt"
	"os"

	"github.com/berachain/offchain-sdk/cmd"
	app "github.com/infrared-dao/infrared-mono-repo/services/indexer/app"
	indexerconfig "github.com/infrared-dao/infrared-mono-repo/services/indexer/config"
)

func main() {
	if err := cmd.BuildBasicRootCmd[indexerconfig.Config](&app.IndexerApp{}).Execute(); err != nil {
		fmt.Fprintf(
			os.Stderr, "Whoops. There was an error while executing your app (%s)", err.Error(),
		)
		os.Exit(1)
	}
}
