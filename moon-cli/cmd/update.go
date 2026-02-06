package cmd

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/spf13/cobra"
)

// updateCmd represents the update command
var updateCmd = &cobra.Command{
	Use:   "update",
	Short: "Updates all the docker images and restart the containers",
	Run: func(cmd *cobra.Command, args []string) {
		c := "docker compose -f " + region + ".yaml pull && docker compose -f" + region + ".yaml up -d && docker image prune -f"
		isTest, _ := cmd.Flags().GetBool("test")
		if isTest {
			c = "docker compose -p test -f test.yaml pull && docker compose -f test.yaml up -d && docker image prune -f"
		}
		command := exec.Command("sh", "-c", c)
		command.Dir = dockerDir
		command.Stdout = os.Stdout
		command.Stderr = os.Stderr
		if err := command.Run(); err != nil {
			fmt.Println(err)
		}
	},
}

func init() {
	updateCmd.PersistentFlags().BoolP("test", "t", false, "Updates only the test.yaml images")
	rootCmd.AddCommand(updateCmd)
}
