## A forma mais barata de subir sua aplicação na AWS

### Subir instância

```
terraform init
```

```
terraform plan
```

```
terraform apply
```

### Criar registro DNS para a Aplicação

Apontar domínio para o IP ```instance_ip``` fornecido.

### Criar arquivos de configuração para o Nginx

1. Acessar ```https://www.digitalocean.com/community/tools/nginx```;

2. Preencher com seu domínio ```app.cloud4devs.com.br```;

3. Desabilitar PHP e Habilitar Reverse Proxy;

4. Trocar porta do Reverse Proxy;

5. Trocar usuário do NGINX para ```nginx```;

6. Acessar instância via SSH;

```
ssh -i server-instance-key ec2-user@INSTANCE-IP;
```

7. Executar ```sudo su```;

8. Seguir passos do próprio site.

