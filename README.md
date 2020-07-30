# Instructions

Pre-requisites:
1. Terraform v0.12.29
2. aws-cli/1.18.69 Python/3.6.9 Linux/4.15.0-112-generic botocore/1.16.19
3. ansible 2.5.1

Steps:
1. git clone https://github.com/vggadde/softram1.git
2. cd softram1
3. Execute "ssh-keygen", create a public private keypair called 'softramtest'
4. Execute "aws configure --profile superhero"
5. Execute "terraform init" and "terraform apply". Enter your machine's public IP (for example 100.16.175.109/32). This step will create the infrastructure (a VPC, subnets, route tables, internet gateway). You public IP is needed to create a security group so only you can access the Jenkins server.
6. Execute "ansible-playbook configure-all.yml" (this installs a jenkins server as a docker image, with configuration being pulled from one GIT repository, and a default build of a nodeJS application from a different repository)
7. You can get the public IP of the newly create Jenkins server from either the command line as ansible is running or via 'jenk-host' file automatically created in the same folder. 
8. Naviate to Jenkins server's public IP on port 80, Jenkins should be up and running with a default NodeJS application ready to be built. 
