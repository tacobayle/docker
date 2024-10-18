scp -r git/docker/compose/alpine-vcf ubuntu@10.206.114.108:/home/ubuntu/docker
ssh ubuntu@10.206.114.108
sudo su -
cd /home/ubuntu/dockeralpine-vcf
docker build -t alpine-hotel .
docker login
docker tag alpine-hotel:latest tacobayle/alpine-hotel:latest
docker push tacobayle/alpine-hotel:latest