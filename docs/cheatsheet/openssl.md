
```bash
# read cert
openssl x509 -text -noout -in $CERT

# check if cert is self singed
openssl x509 -subject -issuer -noout -in $CERT


# create root ca cert
openssl req –new –x509 –days 1826 –key RootCA.key –out RootCA.crt

# generate intermidiate ca key
openssl genrsa –out IntermediateCA.key 4096
# generate intermidiate csr
openssl req –new –key IntermediateCA.key –out IntermediateCA.csr
# generate intermidiate certificate 
openssl x509 –req –days 1000 –in IntermediateCA.csr –CA RootCA.crt –CAkey
key – CAcreateserial –out IntermediateCA.crt
# generate server side 
openssl genrsa –out Server.key 2048

openssl req –new –key Server.key –out Server.csr

# verify rsa key with cert
KEY=
CERT=
diff <(openssl x509 -noout -modulus -in $CERT  | openssl md5 ) <(openssl rsa -noout -modulus -in $KEY | openssl md5) 
```