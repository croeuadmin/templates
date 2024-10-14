1. Generate public private key pair using keytool:
--------------------------------------------------
keytool -genkeypair -keystore keystore.jks -storepass password -alias example.com \
 -keyalg RSA -keysize 2048 -validity 5000 -keypass password \
 -dname 'CN=*.example.com, OU=Sonatype, O=Sonatype, L=Unspecified, ST=Unspecified, C=US' \
 -ext 'SAN=DNS:nexus.example.com,DNS:clm.example.com,DNS:repo.example.com,DNS:www.example.com'


2. Generate PEM encoded public certificate file using keytool:
--------------------------------------------------------------
keytool -exportcert -keystore keystore.jks -alias example.com -rfc > example.cert


3. Convert our Java specific keystore binary".jks" file to a widely compatible PKCS12 keystore ".p12" file:
-----------------------------------------------------------------------------------------------------------
keytool -importkeystore -srckeystore keystore.jks -destkeystore example.p12 -deststoretype PKCS12

keytool -list -keystore example.p12 -storetype PKCS12


4. (Optional) Extract pem (certificate) from ".p12" keystore file ( this is same as step 2, but openssl spits out more verbose contents ):
------------------------------------------------------------------------------------------------------------------------------------------
openssl pkcs12 -nokeys -in example.p12 -out example.pem


5. Extract unencrypted private key file from ".p12" keystore file:
------------------------------------------------------------------
openssl pkcs12 -nocerts -nodes -in example.p12 -out example.key

