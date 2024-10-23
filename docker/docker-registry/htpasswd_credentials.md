# Generating htpasswd for Docker Registry configuration with docker run command

# Docker run command syntax
mkdir auth
docker run \
 --entrypoint htpasswd \
 httpd:2 -Bbn user password > auth/htpasswd

# Docker run command example
mkdir auth
docker run \
 --entrypoint htpasswd \
 httpd:2 -Bbn "admin" "password" > auth/htpasswd

