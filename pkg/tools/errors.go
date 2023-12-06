package tools

import (
	"fmt"
)

// NewError allows modules to create new errors that follow the same pattern.
func NewError(module string, err error) error {
	return fmt.Errorf("%s: %w", module, err)
}
