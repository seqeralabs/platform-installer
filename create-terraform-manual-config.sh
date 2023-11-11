# this should be created by terraform

kubectl create configmap tower-terraform-cfg \
    --from-literal=TOWER_DB_URL="jdbc:mysql://seqera-db.clsfuzxo4ock.eu-west-3.rds.amazonaws.com:3306/seqera?&usePipelineAuth=false&useBatchMultiSend=false" \
    --from-literal=TOWER_REDIS_URL="redis://paolo-tf-cluster-redis.7gtlj9.ng.0001.euw3.cache.amazonaws.com:6379"

kubectl create secret generic tower-terraform-secrets \
    --from-literal=TOWER_DB_PASSWORD="wLYPLhKud6eRIhII"
