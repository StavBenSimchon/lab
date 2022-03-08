
```bash
# read cert
openssl x509 -text -noout -in CERT

# check if cert is self singed
openssl x509 -subject -issuer -noout -in CERT

```