# Monitoring Stack Helm Chart

This Helm chart deploys a complete monitoring stack on Kubernetes, including:

- Prometheus for metrics collection
- Grafana for visualization
- Loki for log aggregation
- Alertmanager for alerting

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- AWS EBS CSI Driver (for AWS deployments)

## Installing the Chart

To install the chart with the release name `monitoring`:

```bash
helm install monitoring ./monitoring
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

### Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.environment` | Environment name | `production` |
| `global.domain` | Base domain for ingress | `fledxy.com` |

### Prometheus

| Parameter | Description | Default |
|-----------|-------------|---------|
| `prometheus.enabled` | Enable Prometheus | `true` |
| `prometheus.replicaCount` | Number of Prometheus replicas | `1` |
| `prometheus.image.repository` | Prometheus image repository | `prom/prometheus` |
| `prometheus.image.tag` | Prometheus image tag | `v2.45.0` |
| `prometheus.persistence.enabled` | Enable persistence | `true` |
| `prometheus.persistence.size` | Size of persistent volume | `20Gi` |
| `prometheus.persistence.storageClass` | Storage class for persistent volume | `gp3` |

### Grafana

| Parameter | Description | Default |
|-----------|-------------|---------|
| `grafana.enabled` | Enable Grafana | `true` |
| `grafana.replicaCount` | Number of Grafana replicas | `1` |
| `grafana.image.repository` | Grafana image repository | `grafana/grafana` |
| `grafana.image.tag` | Grafana image tag | `10.0.0` |
| `grafana.persistence.enabled` | Enable persistence | `true` |
| `grafana.persistence.size` | Size of persistent volume | `20Gi` |
| `grafana.persistence.storageClass` | Storage class for persistent volume | `gp3` |
| `grafana.ingress.enabled` | Enable ingress | `true` |
| `grafana.admin.user` | Admin username | `admin` |
| `grafana.admin.password` | Admin password | `${GRAFANA_ADMIN_PASSWORD}` |

### Loki

| Parameter | Description | Default |
|-----------|-------------|---------|
| `loki.enabled` | Enable Loki | `true` |
| `loki.replicaCount` | Number of Loki replicas | `1` |
| `loki.image.repository` | Loki image repository | `grafana/loki` |
| `loki.image.tag` | Loki image tag | `2.8.0` |
| `loki.persistence.enabled` | Enable persistence | `true` |
| `loki.persistence.size` | Size of persistent volume | `50Gi` |
| `loki.persistence.storageClass` | Storage class for persistent volume | `gp3` |

### Alertmanager

| Parameter | Description | Default |
|-----------|-------------|---------|
| `alertmanager.enabled` | Enable Alertmanager | `true` |
| `alertmanager.replicaCount` | Number of Alertmanager replicas | `1` |
| `alertmanager.image.repository` | Alertmanager image repository | `prom/alertmanager` |
| `alertmanager.image.tag` | Alertmanager image tag | `v0.25.0` |
| `alertmanager.persistence.enabled` | Enable persistence | `true` |
| `alertmanager.persistence.size` | Size of persistent volume | `5Gi` |
| `alertmanager.persistence.storageClass` | Storage class for persistent volume | `gp3` |

## AWS Specific Configuration

For AWS deployments, make sure to:

1. Install the AWS EBS CSI Driver:
```bash
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver
```

2. Create an IAM OIDC provider for your EKS cluster:
```bash
eksctl utils associate-iam-oidc-provider --cluster <cluster-name> --approve
```

3. Create an IAM policy for the EBS CSI Driver:
```bash
aws iam create-policy \
    --policy-name AmazonEKS_EBS_CSI_Driver_Policy \
    --policy-document file://ebs-csi-policy.json
```

4. Create a service account for the EBS CSI Driver:
```bash
eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster <cluster-name> \
    --attach-policy-arn arn:aws:iam::<account-id>:policy/AmazonEKS_EBS_CSI_Driver_Policy \
    --approve
```

## Required Secrets

The following secrets need to be configured:

1. `GRAFANA_ADMIN_PASSWORD`: Password for Grafana admin user
2. `ALERTMANAGER_EMAIL`: Email address for Alertmanager notifications
3. `ALERTMANAGER_EMAIL_PASSWORD`: Password for the email account
4. `AWS_ACCOUNT_ID`: AWS account ID for IAM role configuration

## Uninstalling the Chart

To uninstall/delete the `monitoring` deployment:

```bash
helm uninstall monitoring
```

## Persistence

The chart mounts a Persistent Volume for each component that requires persistence. The volume is created using dynamic provisioning through the specified StorageClass.

## Security

- Grafana admin credentials should be changed after first login
- Prometheus and Alertmanager are not exposed externally by default
- Consider enabling authentication for Loki in production environments
- Use network policies to restrict access between components

## Troubleshooting

1. Check pod status:
```bash
kubectl get pods -n <namespace>
```

2. Check pod logs:
```bash
kubectl logs -n <namespace> <pod-name>
```

3. Check persistent volume claims:
```bash
kubectl get pvc -n <namespace>
```

4. Check services:
```bash
kubectl get svc -n <namespace>
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 