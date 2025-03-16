PROJECT_ID=gcp-jp-tech-team
REGION=asia-northeast1
IMAGE_NAME=mysql

docker build -t asia-northeast1-docker.pkg.dev/${PROJECT_ID}/mysql-graceful-images/${IMAGE_NAME}:8.0 .
docker push asia-northeast1-docker.pkg.dev/${PROJECT_ID}/mysql-graceful-images/${IMAGE_NAME}:8.0

