## Comparativo Cluster Autoscaler vs Karpenter

### Desabilitar Karpenter

```
kubectl scale deploy karpenter --replicas=0 -n karpenter
```

### Acompanhar logs do Cluster Autoscaler

```
kubectl logs -f -l app=cluster-autoscaler -n kube-system
```

### Desabilitar Cluster Autoscaler

```
kubectl scale deploy cluster-autoscaler --replicas=0 -n kibe-system
```

### Acompanhar logs do Cluster Autoscaler

```
kubectl logs -f -l app.kubernetes.io/name=karpenter --container controller -n karpenter
```
