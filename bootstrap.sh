#!/usr/bin/env bash
#

# install ansible (http://docs.ansible.com/intro_installation.html)
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible

# copy examples into /home/vagrant (from inside the mgmt node)
cp -a /vagrant/examples/* /home/vagrant
chown -R vagrant:vagrant /home/vagrant

# configure hosts file for our internal network defined by Vagrantfile
cat >> /etc/hosts <<EOL
# vagrant environment nodes
172.32.22.1  mgmt
172.32.22.11  loadbalancer
172.32.22.2  web1
172.32.22.3  web2
EOL

cat >>/etc/ansible/hosts <<EOL

[webserver]
web1 ansible_ssh_pass=vagrant ansible_ssh_user=vagrant
web2 ansible_ssh_pass=vagrant ansible_ssh_user=vagrant

[lb]
loadbalancer ansible_ssh_pass=vagrant ansible_ssh_user=vagrant

EOL

cat >> /etc/ansible/ansible.cfg <<EOL
[defaults]
host_key_checking = False
EOL

sudo apt-get -y install sshpass
sudo apt-get -y install apache2-utils  

ssh-keyscan -H web2 >> /home/vagrant/.ssh/known_hosts
ssh-keyscan -H web1 >> /home/vagrant/.ssh/known_hosts
ssh-keyscan -H loadbalancer >> /home/vagrant/.ssh/known_hosts
#ssh-keyscan  loadbalancer web2 web1 >> /root/.ssh/known_hosts

cd /vagrant/
sshpass -p vagrant ansible-playbook apache.yml  --ask-pass
sshpass -p vagrant ansible-playbook haproxy.yml --ask-pass

