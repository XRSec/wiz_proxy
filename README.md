# Wiz Note

> 虽然很多人吐槽，但是本地化的文档是真的很重要

### 安装

```bash
# https://www.wiz.cn/zh-cn/docker

mkdir -p /wiz/data /wiz/logs /wiz/backup

docker run --name wiz \
	--restart=always -it -d \
	 -v  /wiz/data:/wiz/storage \
	-v  /etc/localtime:/etc/localtime \
	-p 80:80 wiznote/wizserver
```

### 配置内网访问

- SSH 端口转发可访问
- VPN 网络可访问

#### 创建用户，配置仅转发权限

```bash
# 创建用户
useradd wiz
# 清除密码
passwd -d wiz
# 添加 /sbin/nologin 到默认 shell 列表
echo /sbin/nologin >> /etc/shells
# 切换用户
su wiz
# 更改默认交互 shell
chsh -s /sbin/nologin
# 切换用户
exit
# 尝试切换wiz，能登录就说明修改不成功
su wiz
# 修改用户登录 shell
vi /etc/passwd
# 修改ssh配置文件 /etc/ssh/sshd_config
# 末尾追加 建议修改 127.0.0.1 为内网IP地址
# 仅允许 wiz 用户转发 127.0.0.1:80
Match User wiz
    AllowTcpForwarding yes
    PermitTunnel yes
    PermitOpen 127.0.0.1:80

# 建议使用密钥登录，建议只允许root 用户 和 wiz 用户通过ssh登录
AllowUsers root wiz
PermitRootLogin prohibit-password
PasswordAuthentication no

# 设置单次连接超时时间
ClientAliveInterval 10800
```

### 添加可转发用户

将 有权限的用户的 ssh公钥追加到文件 `/home/wiz/.ssh/authorized_keys`

```bash
mkdir /home/wiz/.ssh/
chmod -R 750 /home/wiz/.ssh
chmod 644 /home/wiz/.ssh/authorized_keys
chown -R wiz:wiz /home/wiz/.ssh
```

当 `/home/wiz/.ssh/authorized_keys` 存在用户的私钥后，用户即可连接 内网 wiz 笔记

```
ssh -C -T -N -L 0.0.0.0:9999:127.0.0.1:80 wiz@服务器IP地址
```

访问 http://localhost:9999 或者 `路由器下的IP地址` 可访问 wiz 笔记 web 页面，建议下载 wiz 客户端，体验更佳

同理，如果朋友也在同一个局域网下，你也可以分享你的笔记给他！

### 增量备份

```bash
#!/bin/env bash
backup_data=$(date +%Y-%m-%d-%H:%M:%S)
echo "###### wiz stop ######"
docker stop wiz >> /wiz/logs/$backup_data.log
backup_num=$(ls -l /wiz/backup/ | wc -l)

echo "###### wiz backup ######"
zip -r /wiz/backup/$backup_data.zip /wiz/data/ >> /wiz/logs/$backup_data.log

if [ $backup_num -gt 30 ]; then
    cd /wiz/backup/ >> /wiz/logs/$backup_data.log
    rm $(ls -l /wiz/backup/ | head -11 | awk '{print $9}') >> /wiz/logs/$backup_data.log
fi

echo "###### wiz start ######"
docker start wiz >> /wiz/logs/$backup_data.log
```


