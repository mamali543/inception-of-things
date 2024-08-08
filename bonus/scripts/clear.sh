sudo gitlab-ctl stop
sudo sv stop /opt/gitlab/service/*
sudo pkill -f gitlab
sudo rm -rf /opt/gitlab
sudo rm -rf /var/opt/gitlab
sudo rm -rf /var/log/gitlab
sudo rm -rf /etc/gitlab
#sudo reboot

