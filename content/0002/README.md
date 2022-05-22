# Observabilidade com Grafana e Prometheus na AWS

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
terraform init
```

```
terraform plan -out=plan
```

```
terraform apply plan
```