CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/wiz_linux_amd64 wiz.go
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o bin/wiz_linux_arm64 wiz.go
CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -o bin/wiz_linux_386 wiz.go
CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o bin/wiz_mac_amd64 wiz.go
CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -o bin/wiz_mac_arm64 wiz.go
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o bin/wiz_windows_amd64.exe wiz.go
CGO_ENABLED=0 GOOS=windows GOARCH=arm64 go build -o bin/wiz_windows_arm64.exe wiz.go
CGO_ENABLED=0 GOOS=windows GOARCH=386 go build -o bin/wiz_windows_386.exe wiz.go