sudo apt-get install haproxy
cd /etc/haproxy/
sudo mv haproxy.cfg haproxy.cfg.old
sudo wget https://raw.githubusercontent.com/josephgunawan97/vagrant-uas/master/haproxy.cfg

sudo service haproxy reload
