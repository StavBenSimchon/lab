# helm
[Menu](https://stavbensimchon.github.io/lab)
(https://github.com/helm/chartmuseum)
(https://github.com/chartmuseum/chart-scanner)
(https://github.com/helm/chartmuseum/pkgs/container/chartmuseum/versions)
```bash
nerdctl run -it --rm --network chartmuseum_default -v ${PWD:2}:/charts chartmuseum/chart-scanner:v0.1.0 --debug --storage=local --storage-local-rootdir=/charts

```

compose example
```bash
# version: '3.9'
services:
   chartmuseum:
    #  image: chartmuseum/chartmuseum:latest
     image: ghcr.io/helm/chartmuseum:v0.14.0
     volumes:
       - .charts:/charts
     restart: always
     entrypoint: /chartmuseum
     command: --auth-anonymous-get
    #  networks:
    #    - new
     environment:
      PORT: 8080
      DEBUG: 1
      STORAGE: "local"
      BASIC_AUTH_USER: master
      BASIC_AUTH_PASS: key
      STORAGE_LOCAL_ROOTDIR: '/charts'
      # STORAGE_AMAZON_BUCKET: "chartmuseum-bucket"
      # STORAGE_AMAZON_PREFIX: ""
      # STORAGE_AMAZON_REGION: "eu-west-1"
     ports:
      - 8080:8080
# networks:
#   new:
```