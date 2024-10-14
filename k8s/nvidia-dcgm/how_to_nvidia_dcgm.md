1. Install Prometheus Community Helm Chart

microk8s helm repo add prometheus-community \
https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories

2. Update the Helm repos

microk8s helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "prometheus-community" chart repository
...Successfully got an update from the "nvidia" chart repository
Update Complete. ⎈Happy Helming!⎈

3. Export the Prometheus Helm variables into a temporary file for inspection and customization

microk8s helm inspect values prometheus-community/kube-prometheus-stack > /tmp/kube-prometheus-stack.values

nano /tmp/kube-prometheus-stack.values

4. Install Prometheus Hel Chart with default options/variables

microk8s helm install prometheus-community/kube-prometheus-stack \
--create-namespace --namespace prometheus \
--generate-name \
--set prometheus.service.type=NodePort \
--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

NAME: kube-prometheus-stack-1722592720
LAST DEPLOYED: Fri Aug  2 11:58:42 2024
NAMESPACE: prometheus
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace prometheus get pods -l "release=kube-prometheus-stack-1722592720"

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.

5. Add GPU Helm Charts

microk8s helm repo add gpu-helm-charts \
https://nvidia.github.io/gpu-monitoring-tools/helm-charts

"gpu-helm-charts" has been added to your repositories

6. Update the Helm repos

microk8s helm repo update

Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "gpu-helm-charts" chart repository
...Successfully got an update from the "prometheus-community" chart repository
...Successfully got an update from the "nvidia" chart repository
Update Complete. ⎈Happy Helming!⎈

7. Install GPU Helm Chart (DCGM Exporter)

microk8s helm install \
  --generate-name \
  gpu-helm-charts/dcgm-exporter

NAME: dcgm-exporter-1722592867
LAST DEPLOYED: Fri Aug  2 12:01:07 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods -n default -l "app.kubernetes.io/name=dcgm-exporter,app.kubernetes.io/instance=dcgm-exporter-1722592867" -o jsonpath="{.items[0].metadata.name}")
  kubectl -n default port-forward $POD_NAME 8080:9400 &
  echo "Visit http://127.0.0.1:8080/metrics to use your application"


Issues/problems related with starting DCGM exporter starting are due to LivenessProbe configuration.
The DCGM cannot start within specified 5 seconds time frame and reports an issue.
To check the default configuration, open the DCGM Exporter DeamonSet:

kubectl edit daemonset.apps/dcgm-exporter

Default values should be configured with following values:

        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /health
            port: 9400
            scheme: HTTP
          initialDelaySeconds: 5
          periodSeconds: 5
          successThreshold: 1
          timeoutSeconds: 1


Fix for DCGM not starting properly:

1. Edit the DCGM Exporter DeamonSet

kubectl edit daemonset.apps/dcgm-exporter

2. Change the "initialDelaySeconds" value from 5 to 60



Fix for Grafana port not being available outside the cluster:

1. Edit the Prometheus Graphana Stack

kubectl edit svc -n prometheus kube-prometheus-stack-1722592720-grafana

2. Change the service type from ClusterIP to Loadbalancer



Additional - Graphana Web UI Login:

Default login: (admin/prom-operator) can be changed in Grafana Web UI or Kubernetes Grafana secrets via Kubernetes Dashboard

