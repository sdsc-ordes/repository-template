package greet

import (
	"log/slog"

	"github.com/spf13/cobra"
)

func Add(parent *cobra.Command, log *slog.Logger) {
	// Add a greet command
	var name string
	greetCmd := &cobra.Command{
		Use:   "greet",
		Short: "Greets the user by name",
		Run: func(_cmd *cobra.Command, _args []string) {
			log.Info("Hello World!", "name", name)
		},
	}

	// Add a flag to the greet command
	greetCmd.Flags().StringVarP(&name, "name", "n", "", "Your name")

	parent.AddCommand(greetCmd)
}
