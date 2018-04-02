# Description

The idea is to prepare sample CI-CD for java app. 

## High level plan

We'll use AWS ECS, Docker, jenkins to automate CI-CD of our sample app. We'll create ECS cluster, jenkins and ECR repo using Cloudformation.
ECS cluster will consists of 3 host that located at separate AZ's. App traffic will be balanced usin ALB that automatically routes, balance and look for service health. We will prepare service that have 3 tasks and placements constraints, so they newer run on the same ECS host. Thus, we'll get multi-AZ 
deployment with automatical failover (ECS +Alb will take care of app health).

To provide automation of build and deployment, we'll bootstrap Jenkins using Cloudformation script. 

After that we could:

- Create CI-CD pipeline using Jenkinsfile and Blue Ocean (not covered here)
- Create 2 Jenkins jobs manually. One of them would build our app on git commit (we'll configure Jenkins and github integration). Second one is universal 
deploying job, that can update our microservice to any version. To do so, it uses aws cli and ECS capabilities.

## Implementation details

There are 3 folders in this repo:

- `automation` contains cloudformation scripts to bootstrap infrastructure
- `docker` contains docker-related stuff
- `jenkins` contains jenkins job

### Quick how-to

1) Build app
```
mvn clean install
```

2) Copy jar file from target folder to docker folder of this repo
3) Open `docker/Dockerfile` and paste name of jar file from step #2
4) Build docker 
5) Create ECR repository by runing cloudformation template `automation/create_ecr-repo.json`
6) Push builded docker file to ECR repo created in #5
7) Create ECS cluster by runing cloudformation template `automation/ecs_cluster_and_service.json`
8) Create Jenkins box by runing cloudformation template `automation/jenkins.json`
9) Login to jenkins, get admin pw by executing
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
10) Create Build docker job (not covered here)
11) Create CI_CD job by adding script from `jenkins/cicd_task` as bash execution block

