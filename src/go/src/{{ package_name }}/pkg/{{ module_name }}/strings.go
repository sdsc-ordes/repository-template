package strs

import (
	"strings"
)

// HasSuffix returns true if `s` contains suffix `suffix`.
func HasSuffix(s string, suffix string) bool {
	return strings.HasSuffix(s, suffix)
}
