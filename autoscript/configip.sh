localip=`ip addr|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|sed 's/\/.*$//'`
sed -i 's/var ip = "192.168.56.102"/var ip = "'$localip'"/g' `grep -rl 192.168 /root/mygithub/caicloudQA/`

