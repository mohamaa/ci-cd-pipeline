# ci-cd-pipeline
This is a sample ci cd pipeline code for a java based application

Jenkins URL: http://3.80.248.206:8080/

Add following rules in aws security group:

HTTP/8081/101.127.5.208/32
SSH/22/101.127.5.208/32

TEST CHANGE TO TEST GITHUB WEBHOOK POLL

sudo yum instal git
sudo yum install java
sudo yum install docker
systemctl enable docker
sudo usermod -a -G docker $USER


High level architecture:

## Continuous integration/Deployment sketch (thought process)

![Image description](./images/cicd-sketch.jpg)


## Continuous integration

![Image description](./images/CI.png)


## Continuous Deployment

![Image description](./images/CD.png)


