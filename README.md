# Userify Server in Docker

Requirements; docker

Very much a work in progress

## Develop

`docker-compose up --build`
`docker-compose exec userify-server bash`
When finished:
`docker-compose down`

## Test



## Build

`docker build . -t local:userify-server --no-cache`

## Deploy:

### Enterprise

`docker run -it -e INSTALL_URL=https://releases.userify.com/dist/userify-enterprise-server.gz -p443:443 --ulimit nofile=1048576 local:userify-server`

### Pro

`docker run -it -e INSTALL_URL=https://releases.userify.com/dist/userify-pro-server.gz -p443:443 --ulimit nofile=1048576 local:userify-server`


