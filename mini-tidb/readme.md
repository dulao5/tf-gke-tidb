```
gcloud container node-pools create tidb-pool \
  --cluster=my-tidb-gke \
  --region=asia-northeast1 \
  --node-locations=asia-northeast1-a,asia-northeast1-b,asia-northeast1-c \
  --num-nodes=1 \
  --machine-type=e2-standard-4 \
  --node-labels=tidb-node=true \
  --node-taints=tidb-node=true:NoSchedule

gcloud container node-pools update tidb-pool   --cluster=my-tidb-gke     --machine-type=e2-standard-8 --region=asia-northeast1
```
