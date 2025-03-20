# Debug: Print environment variables
env | grep -E 'AWS|S3'

# Define secrets path
SECRET_NAMESPACE="rabbitmq-panda"
SECRET_NAME="rabbitmq-tls-secret"
TEMP_DIR="/tmp/rabbitmq-secrets"
mkdir -p $TEMP_DIR


# Test AWS credentials
sudo aws sts get-caller-identity || echo "ERROR: AWS credentials not found!"

# Download secrets from S3
sudo aws s3 cp s3://pz-devops/deploy/deployment/ui/panda-certifcates/ca.pem ca.pem
sudo aws s3 cp s3://pz-devops/deploy/deployment/ui/panda-certifcates/private.pem private.pem
sudo aws s3 cp s3://pz-devops/deploy/deployment/ui/panda-certifcates/public.pem public.pem

ls -lah $TEMP_DIR

# Create Kubernetes secret
kubectl delete secret $SECRET_NAME -n $SECRET_NAMESPACE --ignore-not-found
kubectl create secret generic $SECRET_NAME -n $SECRET_NAMESPACE \
  --from-file=ca.pem=$TEMP_DIR/ca.pem \
  --from-file=private.pem=$TEMP_DIR/private.pem \
  --from-file=public.pem=$TEMP_DIR/public.pem

# Cleanup
rm -rf $TEMP_DIR
