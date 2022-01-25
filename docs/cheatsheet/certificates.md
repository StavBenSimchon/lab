# openssl

```bash
# create ca key
openssl genrsa -out ca.key 2048
# generate x.509 cert interactive
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1825 -out ca.crt
# generate x.509 cert 
openssl req -x509 -new -nodes -batch -key ca.key -subj "/CN=scriptcrunch/C=US/L=CALIFORNIA" 
-days 1825 -out ca.crt



openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -batch \
  -keyout example.key -out example.crt -subj "/CN=stav cert" \
  -addext "subjectAltName=DNS:clickhouse,DNS:localhost,IP:10.0.0.1"


openssl req -subj "/CN=clickhouse" -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout ./keys/server.key -out ./keys/server.crt

openssl dhparam -out ./keys/dhparam.pem 4096

openssl x509 -noout -text -in crt

mkdir -p /usr/local/share/ca-certificates/
cp ./server.crt /usr/local/share/ca-certificates/
update-ca-certificates  

openssl s_client -showcerts -connect example.com:443
```