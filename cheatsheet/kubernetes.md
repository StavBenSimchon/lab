# kubernetes
```bash
kubectl config set-context $(kubectl config current-context) --namespace=${NAMESPACE}

kubectl create serviceaccount jenkins -n default
kubectl create clusterrolebinding default-sa-crb --clusterrole=cluster-admin --serviceaccount=default:jenkins
# create a simple deployment for nginx
kubectl create deployment nginx --image=nginx

# expose deployment with service 
kubectl create service clusterip nginx --tcp=8080:80

# expose service with nginx ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
name: nginx
annotations:
  ingress.kubernetes.io/ssl-redirect: "false"
spec:
  defaultBackend:
    service:
       name: nginx
       port:
          number: 8080
EOF


kubectl port-forward --address 0.0.0.0 pod/shared-crm-app-74b995d798-6446t 8080
kubectl port-forward --address 0.0.0.0 pod/shared-crm-app-74b995d798-6446t 8080:80

kubectl rollout restart daemonset <ds name>

kubectl config set-context --current --namespace=my-namespace

```