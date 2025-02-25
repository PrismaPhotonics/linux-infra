FILE="version.yml"

OFFLINE_DEPLOY=$(yq -r .offline_deploy "$FILE")
THIRD_SUBNET_OCTET=$(yq -r .third_subnet_octet "$FILE")
SECOND_SUBNET_OCTET=$(yq -r .second_subnet_octet "$FILE")

export OFFLINE_DEPLOY
export THIRD_SUBNET_OCTET
export SECOND_SUBNET_OCTET

echo "Exported environment variables:"
echo "OFFLINE_DEPLOY=${OFFLINE_DEPLOY}"
echo "THIRD_SUBNET_OCTET=${THIRD_SUBNET_OCTET}"
echo "SECOND_SUBNET_OCTET=${SECOND_SUBNET_OCTET}"