# Observabilidade com Grafana e Prometheus na AWS

## Clonar repositório da Cloud4Devs

```
git clone https://github.com/cloud4devs/support-material.git
```

## Configuração de credenciais da AWS

```
aws configure
```

```
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: 
Default output format [None]:
```

## Criar os recursos com o Terraform

```
cd support-material/content/0002/terraform
```

```
terraform init
```

```
terraform plan -out=plan
```

```
terraform apply plan
```

## Configurar credencias do Kubernetes

```
aws eks update-kubeconfig --region us-east-1 --name cloud4devs
```

## Instalar a kube-prometheus Stack


```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

```

```
helm repo update
```

```
helm install prometheus-stack prometheus-community/kube-prometheus-stack --set grafana.service.type=LoadBalancer
```

### Senha Default do Grafana

```
login: admin
password: prom-operator
```

## Criar os recursos do Kubernetes

```
cd ../kubernetes
```

```
kubectl apply -f .
```

## Deletar os recursos do Kubernetes

```
kubectl delete -f .
```

## Deletar os recursos do Terraform


```
terraform plan -out=plan -destroy
```

```
terraform apply plan
```
