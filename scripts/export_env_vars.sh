FILE="version.yml"

OFFLINE_DEPLOY=$(yq -r .offlineDeployPath "$FILE")
THREE_FIRST_OCTETS=$(yq -r .firstThreeOctets "$FILE")
PROJECT_NAME=$(yq -r .projectName "$FILE")
LINUX_USER=$(yq -r .linuxUser "$FILE")

export OFFLINE_DEPLOY
export THREE_FIRST_OCTETS
export PROJECT_NAM
export LINUX_USER

echo "Exported environment variables:"
echo "OFFLINE_DEPLOY=${OFFLINE_DEPLOY}"
echo "THREE_FIRST_OCTETS=${THREE_FIRST_OCTETS}"
echo "PROJECT_NAME=${PROJECT_NAME}"
echo "LINUX_USER=${LINUX_USER}"