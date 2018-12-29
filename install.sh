set_proxy
sudo -E dnf install dnf-plugins-core -y
sudo -E dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
#sudo -E dnf config-manager --set-enabled docker-ce-edge
#sudo -E dnf config-manager --set-disabled docker-ce-edge
sudo -E dnf config-manager --set-enabled docker-ce-test
sudo -E dnf install docker-ce -y
sudo usermod -aG docker zdzich

