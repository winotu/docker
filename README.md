# docker_proxy.sh
Script for setting or unsetting proxy from docker

## Requirements
- jq - powerful JSON manipulator
- update docker_proxy.sh and provide proxy address

## How to
```
# Add proxy settings
./docker_proxy.sh 

# Remove proxy settings
./docker_proxy.sh -p
```
### Debugging
```
systemctl show --property=Environment docker
```

# install.sh
Some basic docker-ce install commands for Fedora can be easily substitude with get docker sh script
