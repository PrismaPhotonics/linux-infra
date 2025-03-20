# Debug: Print environment variables
echo "*******************ENVIRONMENT VARIABLES*******************"
env | grep -E 'AWS|S3'

# Define secrets path
SECRET_NAMESPACE="rabbitmq-panda"
SECRET_NAME="rabbitmq-tls-secret"
TEMP_DIR="/tmp/rabbitmq-secrets"
mkdir -p $TEMP_DIR

echo "*******************Start Downloading*******************"

# Test AWS credentials
sudo aws sts get-caller-identity || echo "ERROR: AWS credentials not found!"

# Download secrets from S3
sudo s3cmd --debug get s3://pz-devops/deploy/deployment/ui/panda-certifcates/ca.pem $TEMP_DIR/ca.pem
sudo s3cmd --debug get s3://pz-devops/deploy/deployment/ui/panda-certifcates/private.pem $TEMP_DIR/private.pem
sudo s3cmd --debug get s3://pz-devops/deploy/deployment/ui/panda-certifcates/public.pem $TEMP_DIR/public.pem

echo "*******************Finish Downloading*******************"
ls -lah $TEMP_DIR
echo "*******************Finish Listing Files*******************"

# Create Kubernetes secret
kubectl delete secret $SECRET_NAME -n $SECRET_NAMESPACE --ignore-not-found
kubectl create secret generic $SECRET_NAME -n $SECRET_NAMESPACE \
  --from-file=ca.pem=$TEMP_DIR/ca.pem \
  --from-file=private.pem=$TEMP_DIR/private.pem \
  --from-file=public.pem=$TEMP_DIR/public.pem

# Cleanup
rm -rf $TEMP_DIR
