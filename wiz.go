package main

import (
	"fmt"
	"log"
	"os/exec"
	"regexp"
	"runtime"
)

func checkError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
func main() {
	if runtime.GOOS == "linux" || runtime.GOOS == "darwin" {
		fmt.Printf("\n\u001B[0;0;34m#########################\u001B\n\n\u001B[0;0;35mWorking on the WIZ tunnel\u001B[0m")
		sshProxyPid, sshProxyPidErr := exec.Command("/bin/bash", "-c", "ps -e | grep '0.0.0.0:9999' | grep -v grep | cut -d ' ' -f 1").Output()
		checkError(sshProxyPidErr)
		if string(sshProxyPid) == "" {
			_ = exec.Command("/bin/bash", "-c", "ssh -C -T -N -L 0.0.0.0:9999:10.0.12.3:80 wiz@192.168.1.12 &").Run()
		} else {
			killStatus, killError := exec.Command("/bin/bash", "-c", "kill "+string(sshProxyPid)).Output()
			checkError(killError)
			fmt.Println(string(killStatus))
			_ = exec.Command("/bin/bash", "-c", "ssh -C -T -N -L 0.0.0.0:9999:10.0.12.3:80 wiz@192.168.1.12 &").Run()
		}
		fmt.Printf("\n\u001B[0;0;34m#########################\u001B[0m")
	} else if runtime.GOOS == "windows" {
		fmt.Printf("\n#########################\n\nWorking on the WIZ tunnel\n\n")
		sshProxyPids, _ := exec.Command("cmd", "/C", "netstat -ano | findstr 0.0.0.0:9999").Output()

		if string(sshProxyPids) == "" {
			_ = exec.Command("cmd", "/C", "start /b ssh -C -T -N -L 0.0.0.0:9999:10.0.12.3:80 wiz@192.168.1.12").Run()
		} else {
			sshProxyPid := regexp.MustCompile(`\d{1,5}`).FindAllString(string(sshProxyPids), -1)[10]
			killStatus, killError := exec.Command("cmd", "/C", "taskkill /f /PID "+string(sshProxyPid)).Output()
			checkError(killError)
			fmt.Println(string(killStatus))
			_ = exec.Command("cmd", "/C", "start /b ssh -C -T -N -L 0.0.0.0:9999:10.0.12.3:80 wiz@192.168.1.12 &").Run()
		}
		fmt.Printf("#########################\n")
	}

}
