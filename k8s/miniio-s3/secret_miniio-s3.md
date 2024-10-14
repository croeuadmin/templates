# Create Kubernetes Secret for MiniIO
# Replace secret name, files and values created in secret as needed

kubectl create secret generic miniio-s3-creds --from-file=USER=./secrets/secret_user.txt --from-file=PASS=./secrets/secret_password.txt
