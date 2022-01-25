# git

* squash  last 3 commits
```bash
git reset --soft HEAD~3
git reset --soft HEAD~N
git add -A
git commit -m ""
git push origin (branch_name)
```
## git server alpine

```bash
addgroup git && \
adduser -D -G git git && \
mkdir -p -m 770 /srv/git && \
chgrp -R git /srv/git 

apk --no-cache add git


mkdir ~/.ssh && chmod 700 ~/.ssh && \
touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys 
echo "${key}" >> ~/.ssh/authorized_keys 

# to start sshd server

# deluser git ;\
# delgroup git


mkdir /srv/git/project.git && \
cd /srv/git/project.git && git init --bare

chown u+x dir/file

chgrp -R {Group name} dir_name/

```

# alpine 

```bash
addgroup -S git && adduser -S git -G git

chgrp -R {Group name} dir_name/
adduser --disabled-password --gecos "" --no-create-home --uid "$ID" "$USER" 
adduser --disabled-password --gecos "" --no-create-home  "$USER" 
apk --no-cache add shadow && \
    usermod -u 2500 elasticsearch && \
    groupmod -g 2500 elasticsearch
# make hased password
mkpasswd --method=SHA-512 --stdin
# change pass for user
passwd user
# expire password and he'll have to chage
passwd --expire user
```
# linux
```bash
# add key footprint
ssh-keyscan -H `minikube ip` > ~/.ssh/known_hosts
# create private key
openssl genrsa -out privatekey.pem 1024
# create new signed certificate 
openssl req -new -x509 -key privatekey.pem -out publickey.cer -days 1825

To Convert "BEGIN OPENSSH PRIVATE KEY" to "BEGIN RSA PRIVATE KEY"

ssh-keygen -p -m PEM -f ~/.ssh/id_rsa

useradd admin
useradd -d /data/projects -u 1000 -g 500 -e 2014-03-27 -f 45 -s /sbin/nologin tarunika  # home dir , -3 expire date , -f expire pass -s shell 
useradd -G admins,webadmin,developers tarunika  # home dir
useradd -u 999 navin
useradd -M shilpi # no home dir
passwd admin
id tecmint

groupadd –r sshusers
usermod –a –G sshusers admin
AllowGroups sshusers
AllowUsers admin
/usr/sbin/sshd –t

groupadd –r sshusers
adduser
addgroup sshusers
adduser -G sshusers myssh
deluser myssh

pip install -r requirements.txt --no-index --find-links file:///tmp/packages
# network check
sudo lsof -i
sudo netstat -lptu
sudo netstat -tulpn

```
# Docker

```bash

Copy-VMFile -Name "minikube" -SourcePath 'C:\Stav\Git\repos\mylab-0\ex\jenkins\Dockerfile' -DestinationPath "/data" -FileSource Host  
Copy-VMFile -Name "minikube" -SourcePath 'C:\Stav\Git\repos\mylab-0\ex\jenkins\Dockerfile' -DestinationPath "/data" -FileSource Host  CreateFullPath

docker run -it --rm --name app alpine:latest sh
docker run -it --rm --name app -p 5000:5000 alpine:latest sh 
docker run -d --name app -p 5000:5000 dummy-app

docker ps -f name=app
docker rm -f $(docker ps -q -f name=app)

```

# kubernetes

```bash

kubectl run -it --rm --generator=run-pod/v1 --image alpine sh

kubectl create ns jenkins
kubectl config set-context --current --namespace=<namespace>

kubectl run nginx --image=nginx --replicas=1

# Validate it
kubectl config view --minify | grep namespace:

kubectl get all -n example

kubectl get pod -w -l app=zk

# context

kubectl config current-context
kubectl config view
kubectl config set-context test --namespace=test --cluster=docker-desktop --user=docker-desktop
kubectl config use-context test

## validation
kubectl port-forward pod/dummy-app-7b74c895b9-kq5rv 8080:5000
# after deployment
kubectl port-forward deployment.apps/dummy-app 8080:5000
# after service
kubectl port-forward service/dummy-app 8080:5000

kubectl proxy --port=8080

# proxy
kubectl proxy
http://localhost:8001/api/v1/namespaces/test/services/http:dummy-app:5000/proxy/
```
## patching vs merging
stratigic 
merging (json merge)
patch (json patch)

jsonpatch is declerative file with features like (if key exists, add,remove,delete,copy,move keys/values)
```bash

kubectl get deployment dummy-app --output yaml
# check the yaml before patching
# the patched file can be just the change

kubectl patch deploy dummy-app --patch "$(cat ./patch.yaml)"
kubectl patch deploy dummy-app --type merge --patch "$(cat ./patch.yaml)"
kubectl patch deploy dummy-app --type strategic --patch "$(cat ./patch.yaml)"
kubectl patch deploy dummy-app --type json --patch "$(cat ./patch.yaml)"


kubectl get events



kubectl run --rm -it --image=alpine --restart=Never --overrides='
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "volumeMounts": [{
              "mountPath": "/tmp/",
              "name": "test"
            }]
          }
        ],
        "volumes": [{
          "name":"test",
          "configMap":{"name":"prometheus"}
        }]
      }
    }
  }
}
' -- bash





#######
# namespaces can talk via
<Service Aame>.<Namespace Name>.svc.cluster.local
```

# sshd_cofig example
## config
```bash
PermitEmptyPasswords no
PasswordAuthentication no
ChallengeResponseAuthentication no
PasswordAuthentication no
LogLevel VERBOSE
Banner /etc/banner
AllowAgentForwarding no

UsePAM no

# hardening 
AllowTcpForwarding no
AllowStreamLocalForwarding no
GatewayPorts no
PermitTunnel no
```
## cmd
```bash
apt install git
groupadd git 
# alpine
addgroup
sudo chown ted:git git
chmod 775 git
chmod g+s git
git config --global core.sharedRepository group
git clone --bare source-repo-dir /srv/git/projectname.git
git clone --bare /srv/git/projectname.git
```

# helm
## ref
* [helm](https://helm.sh/docs/topics/chart_repository/)
```bash
helm install --dry-run --debug ./mychart --set service.internalPort=8080

## render values with chart
helm lint . && helm template <path to dir>

helm install test . --debug --atomic
helm upgrade test . --debug --atomic

helm dep update <path>
```

# Misc
```bash
# create keys and sign cert
openssl genrsa -out client.key 4096
openssl req -new -x509 -text -key client.key -out client.cert

http://localhost:8080/api/v1/namespaces/default/services/SERVICE-NAME:PORT-NAME/proxy/

```
http://localhost:8080/api/v1/namespaces/default/services/SERVICE-NAME:PORT-NAME/proxy/