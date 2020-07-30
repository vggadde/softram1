Pre-requisites
1. Terraform v0.12.29
2. aws-cli/1.18.69 Python/3.6.9 Linux/4.15.0-112-generic botocore/1.16.19
3. ansible 2.5.1

1. Update the public key logic in main.tf
2. aws configure --profile superhero
3. Navigate to folder and execute ansible-playbook install-basics.yml 
4. CHange myIP in terraform secrets
5. Several warning on security in jenkins server.. ignoring for now, but should be fixed in production.
6. docker compose should run in directory where docker-compose fils is in. 
7. adjust permissions for kryptonite private key after