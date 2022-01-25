# k3d 
[Menu](https://stavbensimchon.github.io/lab)

```bash
# create single cluster
k3d cluster create mycluster

# create complex cluster
# server = master , agent = worker node
k3d cluster create multinode --agents 2 --servers 2

# add server to the cluster 
k3d node create server --role server --cluster multinode

# add an worker node to cluter                 
k3d node create myagent --role agent --cluster multinode

```