# softram1

Pre-requisites

Terraform v0.12.29

aws-cli/1.18.69 Python/3.6.9 Linux/4.15.0-112-generic botocore/1.16.19

ansible 2.5.1

Create softramtest public private keypair

aws configure --profile superhero

Navigate to folder and execute ansible-playbook install-basics.yml

CHange myIP in terraform secrets

Several warning on security in jenkins server.. ignoring for now, but should be fixed in production.

docker compose should run in directory where docker-compose fils is in.

adjust permissions for kryptonite private key after
