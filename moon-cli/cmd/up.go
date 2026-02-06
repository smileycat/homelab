package cmd

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/spf13/cobra"
)

// upCmd represents the up command
var upCmd = &cobra.Command{
	Use:   "up",
	Short: "Brings up all the docker containers",
	Run: func(cmd *cobra.Command, args []string) {
		cmdStr := "docker compose -f " + region + ".yaml up -d"
		isTest, _ := cmd.Flags().GetBool("test")
		if isTest {
			cmdStr = "docker compose -p test -f test.yaml up -d"
		}
		command := exec.Command("sh", "-c", cmdStr)
		command.Dir = dockerDir
		command.Stdout = os.Stdout
		command.Stderr = os.Stderr
		if err := command.Run(); err != nil {
			fmt.Println(err)
		}
	},
}

func init() {
	upCmd.PersistentFlags().BoolP("test", "t", false, "Brings up the test.yaml with docker compose")
	rootCmd.AddCommand(upCmd)
}
