scp -r git/docker/compose/alpine-vcf ubuntu@10.206.114.108:/home/ubuntu/docker
ssh ubuntu@10.206.114.108
sudo su -
docker build -t alpine-vsphere:8 .
docker login
docker tag alpine-vsphere:8 tacobayle/alpine-vsphere:8
docker push tacobayle/alpine-vsphere:8