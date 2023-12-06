package util

import (
	"errors"

	"github.com/infrared-dao/infrared-mono-repo/pkg/tools"
)

// All the errors that can be returned by the util package.
var (
	ErrEmptyContext = tools.NewError("util", errors.New("empty context"))
	ErrEmptyPubKey  = tools.NewError("util", errors.New("empty public key"))
	ErrEmptyPrivKey = tools.NewError("util", errors.New("empty private key"))
)
