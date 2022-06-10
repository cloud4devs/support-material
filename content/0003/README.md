# Logs com Loki no Kubernetes

## Prepar o cluster EKS e o RDS

Siga o material abaixo até o step ```Configurar credencias do Kubernetes```:

https://github.com/cloud4devs/support-material/tree/main/content/0002


## Instalar o Loki e Grafana


```
helm repo add grafana https://grafana.github.io/helm-charts
```

```
helm repo update
```

```
helm upgrade --install loki grafana/loki-stack --set grafana.enabled=true --set grafana.service.type=LoadBalancer
```

### Acesso ao Grafana

O login do Grafana é ```admin```, a senha pode ser obtida com o seguinte comando:

```
kubectl get secret  loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## Criar os recursos do Kubernetes

Acesse os arquivos no diretório ```support-material/content/0003/kubernetes/```

```
kubectl apply -f .
```

Obs: Não esqueça de alterar a variável ```HOST_URL``` do deployment.yaml. 

## Documentação LogQL

https://sbcode.net/grafana/logql/

## Deletar os recursos

Siga o material abaixo a partir do step ```Deletar os recursos do Kubernetes```:

https://github.com/cloud4devs/support-material/tree/main/content/0002

