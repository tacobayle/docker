scp -r git/docker/compose/alpine-vcf ubuntu@10.206.114.108:/home/ubuntu/docker
ssh ubuntu@10.206.114.108
sudo su -
cd /home/ubuntu/dockeralpine-vcf
docker build -t alpine-vcf .
docker login
docker tag alpine-vcf:latest tacobayle/alpine-vcf:latest
docker push tacobayle/alpine-vcf:latest