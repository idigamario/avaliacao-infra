# Implementar o Ingress Controller NGINX

## Configurar controle de acesso baseado em função (RBAC).

1. Criar um namespace e um service account:
```
kubectl apply -f ns-and-sa.yml 
```

2. Criar Cluster Role e Role binding para o service account:
```
kubectl apply -f deployments/rbac/rbac.yml
```

### Caso utilizar o Nginx App Protect ou Nginx App protect DoS, precisará de roles adicionais

1. NGINX App Protect (apenas):
```
kubectl apply -f ap-rbac.yml
```

2. NGINX App Protect DoS (apenas):
```
kubectl apply -f apdos-rbac.yml
```

## Criar Commom Resources

1. Criar Secret para o certificado TLS
```
kubectl apply -f server-secret.yml
```
2. ConfigMap para caso de customização do Ingress Controller
```
kubectl apply -f nginx-cm.yml
```
3. Criar um IngressClass (O Ingress Controller não iniciará sem esse resource):
```
kubectl apply -f ingress-class.yml
```

## Criar CRDs essenciais

- Aplicar todas as CRDs essenciais em um único yml:
```
kubectl apply -f crd.yml
```

## Deploy do Ingress Controller

- Utilizando um DaemonSet:
```
kubectl apply -f daemonset.yml
```

## Verificação

```
kubectl get pods --namespace=nginx-ingress
```