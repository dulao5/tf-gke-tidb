```
gcloud container node-pools create mysql-pool \
  --cluster=my-cluster \
  --region=asia-northeast1 \
  --node-locations=asia-northeast1-a,asia-northeast1-b,asia-northeast1-c \
  --num-nodes=1 \
  --machine-type=e2-standard-4 \
  --node-labels=mysql-node=true \
  --node-taints=mysql-node=true:NoSchedule
```
