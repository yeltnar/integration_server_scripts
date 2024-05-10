# get entitlement keys here
# https://myibm.ibm.com/products-services/containerlibrary

# get image reference here # example: cp.icr.io/cp/appc/ace:12.0.12.0-r1@sha256:33000e4b20570524c44203ba32b047cb752d3935fcd6dfa8b94ee862f75993aa
# https://www.ibm.com/docs/en/app-connect/12.0?topic=cacerid-building-sample-app-connect-enterprise-image-using-docker

if [ -e .env ]; then
	source .env; 
fi

if [ -z "$ContainerRuntime" ]; then
	ContainerRuntime="podman";
fi

if [ -z "$IMAGE_HOST" ]; then
		echo "IMAGE_HOST env var not defined; exiting";
fi

$ContainerRuntime login --get-login "$IMAGE_HOST";
if [ $? -eq 0 ]; then
	echo "login confirmed";
else
	echo "logging in...";

	if [ -z "$EntitlementKey" ]; then
		echo "EntitlementKey env var not defined; exiting";
		exit -1;
	fi

	$ContainerRuntime login cp.icr.io -u cp -p "$EntitlementKey";
fi

if [ -z "$IMAGE_PATH" ]; then
	echo "IMAGE_PATH environment variable is undefined; exiting";
	exit -1
fi
if [ -z "$IMAGE_NAME" ]; then
	echo "IMAGE_NAME environment variable is undefined; exiting";
	exit -1
fi
if [ -z "$IMAGE_TAG" ]; then
	echo "IMAGE_TAG environment variable is undefined; exiting";
	exit -1
fi

IMAGE="$IMAGE_PATH/$IMAGE_NAME:$IMAGE_TAG";

$ContainerRuntime pull $IMAGE;
