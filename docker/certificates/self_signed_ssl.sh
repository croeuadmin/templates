#!/bin/bash

# Create directory with all the certificates and signing requests (replace values as needed)
mkdir ssl_certs
cd ssl_certs

# Create root CA & Private key (replace values as needed)
openssl req -x509 \
            -sha256 -days 3650 \
            -nodes \
            -newkey rsa:4096 \
            -subj "/CN=********/C=**/L=********" \
            -keyout rootCA.key -out rootCA.crt 

# Generate Private key
openssl genrsa -out server_private.key 4096

# Create certificate signing request (csr) configuration (replace values as needed)
cat > csr.conf <<EOF
[ req ]
default_bits = 4096
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = **
L = ********
O = ********
OU = ********
CN = ********

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ********
DNS.2 = ********
IP.1 = xxx.xxx.xxx.xxx

EOF

# Create CSR request using previously generated private key
openssl req -new -key server_private.key -out signing_request.csr -config csr.conf

# Create external config file for the certificate
cat > cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ********
DNS.2 = ********
IP.1 = xxx.xxx.xxx.xxx

EOF

# Create SSl certificate with self signed root CA
openssl x509 -req \
    -in signing_request.csr \
    -CA rootCA.crt -CAkey rootCA.key \
    -CAcreateserial -out server_certificate.crt \
    -days 3650 \
    -sha256 -extfile cert.conf
