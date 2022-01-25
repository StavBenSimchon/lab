# cheatsheet

## ubuntu
```bash
adduser --disabled-password --ingroup sudo github

userdel username
userdel -r username # remove with home dir

apt install sudo -y
usermod -aG sudo username

```
## alpine
```bash

# glibc on alpine
wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk && \
apk add glibc-2.32-r0.apk && rm -f glibc-2.32-r0.apk

# building env
apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go

# man 
apk add --no-cache man-pages man-db man-db-doc man-db-lang
apk list -I |
  sed -rn '/-doc/! s/([a-z-]+[a-z]).*/\1/p' |
  awk '{ print system("apk info \""$1"-doc\" > /dev/null") == 0 ? $1 "-doc" : "" }' |
  xargs apk add
```
## jenkins
```bash
println ""
def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()
plugins.each {println "${it.getShortName()}"}
println ""
println "Total number of plugins: ${plugins.size()}"
```
## docker 

```bash
# connect already running container to network
docker network connect multi-host-network container1

```

## docker compose
```bash
  docker compose up -d --remove-orphans --quiet-pull
  docker compose down --remove-orphans -v

```
## kubernetes
```bash
## kubernetes
# states
kubernetes:
    node:
      - TerminatedAllPods       # Terminated All Pods      (information)
      - RegisteredNode          # Node Registered          (information)*
      - RemovingNode            # Removing Node            (information)*
      - DeletingNode            # Deleting Node            (information)*
      - DeletingAllPods         # Deleting All Pods        (information)
      - TerminatingEvictedPod   # Terminating Evicted Pod  (information)*
      - NodeReady               # Node Ready               (information)*
      - NodeNotReady            # Node not Ready           (information)*
      - NodeSchedulable         # Node is Schedulable      (information)*
      - NodeNotSchedulable      # Node is not Schedulable  (information)*
      - CIDRNotAvailable        # CIDR not Available       (information)*
      - CIDRAssignmentFailed    # CIDR Assignment Failed   (information)*
      - Starting                # Starting Kubelet         (information)*
      - KubeletSetupFailed      # Kubelet Setup Failed     (warning)*
      - FailedMount             # Volume Mount Failed      (warning)*
      - NodeSelectorMismatching # Node Selector Mismatch   (warning)*
      - InsufficientFreeCPU     # Insufficient Free CPU    (warning)*
      - InsufficientFreeMemory  # Insufficient Free Mem    (warning)*
      - OutOfDisk               # Out of Disk              (information)*
      - HostNetworkNotSupported # Host Ntw not Supported   (warning)*
      - NilShaper               # Undefined Shaper         (warning)*
      - Rebooted                # Node Rebooted            (warning)*
      - NodeHasSufficientDisk   # Node Has Sufficient Disk (information)*
      - NodeOutOfDisk           # Node Out of Disk Space   (information)*
      - InvalidDiskCapacity     # Invalid Disk Capacity    (warning)*
      - FreeDiskSpaceFailed     # Free Disk Space Failed   (warning)*
    pod:
      - Pulling           # Pulling Container Image          (information)
      - Pulled            # Ctr Img Pulled                   (information)
      - Failed            # Ctr Img Pull/Create/Start Fail   (warning)*
      - InspectFailed     # Ctr Img Inspect Failed           (warning)*
      - ErrImageNeverPull # Ctr Img NeverPull Policy Violate (warning)*
      - BackOff           # Back Off Ctr Start, Image Pull   (warning)
      - Created           # Container Created                (information)
      - Started           # Container Started                (information)
      - Killing           # Killing Container                (information)*
      - Unhealthy         # Container Unhealthy              (warning)
      - FailedSync        # Pod Sync Failed                  (warning)
      - FailedValidation  # Failed Pod Config Validation     (warning)
      - OutOfDisk         # Out of Disk                      (information)*
      - HostPortConflict  # Host/Port Conflict               (warning)*
    replicationController:
      - SuccessfulCreate    # Pod Created        (information)*
      - FailedCreate        # Pod Create Failed  (warning)*
      - SuccessfulDelete    # Pod Deleted        (information)*
      - FailedDelete        # Pod Delete Failed  (warning)*
# view config
kubectl config view --minify


# misc
kubectl get pods -o=name
kubectl get pods -o=name | tr -d 'pod/'
# update namespace
k create ns test
kubectl config set-context --current --namespace=test


# deployment
kubectl rollout restart deployment



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
```
## Linux

```bash
# makin ca cert
mkdir CA
cd CA
openssl genrsa -aes256 -out my-own-ca.key 2048
openssl req -new -x509 -days 3650 -key my-own-ca.key \
  -sha256 -extensions v3_ca -out my-own-ca.crt

# Generate server.key and server.crt signed by our local CA. 
openssl genrsa -out server.key 2048
openssl req -sha256 -new -key server.key -out server.csr
openssl x509 -sha256 -req -in server.csr -CA my-own-ca.crt \
  -CAkey my-own-ca.key -CAcreateserial -out server.crt -days 365
# Confirm the certificate is valid. 
openssl verify -CAfile my-own-ca.crt server.crt

cp my-own-ca.crt /usr/local/share/ca-certificates/root.ca.crt

update-ca-certificates

openssl dhparam -out /etc/clickhouse-server/dhparam.pem 4096


# find utils
https://www.tecmint.com/35-practical-examples-of-linux-find-command/
https://geekflare.com/linux-find-commands/

```

## git
```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git config --global core.excludesfile ~/.gitignore
git config --global pull.rebase true
git config --global fetch.prune true
git config --global init.defaultBranch main

prefix='2.17*'
git tag --list --sort=-version:refname ${prefix} | head -n 1
```

## go 

``` bash
export GOARCH=armv7
export GOOS=linux
export GOROOT="/usr/lib/go"

export GOPATH="/go"
export PATH="/go/bin:$PATH"
mkdir -p /go ${GOPATH}/src ${GOPATH}/bin

```