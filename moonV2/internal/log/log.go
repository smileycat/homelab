package log

import (
	"fmt"
	"os"
	"time"
)

func Info(format string, a ...any) {
	fmt.Print(time.Now().Format("2006-01-02 15:04:05"), " INFO: ")
	fmt.Printf(format+"\n", a...)
}

func Warn(format string, a ...any) {
	fmt.Print(time.Now().Format("2006-01-02 15:04:05"), " WARN: ")
	fmt.Printf(format+"\n", a...)
}

func Error(format string, a ...any) {
	fmt.Fprint(os.Stderr, time.Now().Format("2006-01-02 15:04:05"), " ERROR: ")
	fmt.Printf(format+"\n", a...)
}
