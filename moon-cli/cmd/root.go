package cmd

import (
	"os"
	"os/user"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "moon-cli",
	Short: "A brief description of your application",
}

var region string
var dockerDir string

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.
	// rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.moon-cli.yaml)")

	homedir, _ := os.UserHomeDir()
	dockerDir = homedir + "/homelab/docker"

	user, _ := user.Current()
	if user.Username == "penguin" {
		region = "au"
	} else if user.Username == "polarbear" {
		region = "tw"
	}
}
