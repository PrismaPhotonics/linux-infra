# Define secrets path
SECRET_NAMESPACE="rabbitmq-panda"
SECRET_NAME="rabbitmq-tls-secret"
TEMP_DIR="/tmp/rabbitmq-secrets"
mkdir -p $TEMP_DIR
echo "*******************start to downlaod*******************"
# Download secrets from S3
aws s3 cp s3://pz-devops/deploy/deployment/ui/panda-certifcates/ca.pem /etc/panda-certificates/ca.pem
aws s3 cp s3://pz-devops/deploy/deployment/ui/panda-certifcates/private.pem /etc/panda-certificates/private.pem
aws s3 cp s3://pz-devops/deploy/deployment/ui/panda-certifcates/public.pem /etc/panda-certificates/public.pem
echo "*******************finish to downlaod*******************"
ls $TEMP_DIR
echo "*******************finish to ls*******************"

# Create Kubernetes secret
kubectl delete secret $SECRET_NAME -n $SECRET_NAMESPACE --ignore-not-found
kubectl create secret generic $SECRET_NAME -n $SECRET_NAMESPACE \
  --from-file=ca.pem=$TEMP_DIR/ca.pem \
  --from-file=private.pem=$TEMP_DIR/private.pem \
  --from-file=public.pem=$TEMP_DIR/public.pem
