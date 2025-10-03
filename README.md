# Alertmanager Signal Helm Chart

This Helm chart deploys Alertmanager Webhook to Signal integration using two main components:

1. Signal CLI REST API: Runs a Signal client in a container and handles sending messages.
2. Alertmanager Webhook (alertmanager-webhook-signal): Receives alerts from Prometheus Alertmanager and forwards them to Signal via the Signal CLI REST API.

## Usage

### After deploying the chart:

Get the QR code to link your Signal device:

kubectl logs -f alertmanager-signal-<pod-id> -c webhook

Scan the QR code with your Signal app to link your number with the signal-cli container.

The webhook listens on port 10000.

#### Managing Groups

If you want to send messages to a Signal group, after scanning the QR code you should run the following commands:

```bash
kubectl exec -it alertmanager-signal-<id> -c signal-cli -- bash


curl -X 'GET' \
  'http://localhost:8080/v1/groups/<phone_number>' \
  -H 'accept: application/json'
```

Use the Id field from the output in your webhook configuration under recipients:

recipients:
  - "group.<group-id>"

####  Verify Alerts:

Alerts sent by Prometheus should now appear as Signal messages for the configured recipients.

### Openshift

ServiceAccount and SCC Requirements:
On OpenShift, the Signal CLI REST API container runs as UID 1000. Openshift which will prevent the pod from starting unless the container is allowed to run as this UID.

Grant anyuid to the ServiceAccount:
Before deploying the chart, create the ServiceAccount and grant it the anyuid SCC:

```bash
oc adm policy add-scc-to-user anyuid -z alertmanager-signal-sa -n <namespace>
```