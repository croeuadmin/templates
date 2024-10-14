# ENV info for K8s Transmission Deployment

1. Create Kubernetes secrets for user and password:

kubectl create secret generic transmission-app-login --from-file=USER=./secrets/secret_user.txt --from-file=PASS=./secrets/secret_password.txt

2. Deploy the Transmission application deployment:

kubectl apply -f deploy_transmission.yaml

3. Deploy the Transmission application service:

kubectl apply -f service_transmission.yaml

