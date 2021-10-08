cd deploy/packer &&
packer build --var-file=env.pkrvars.hcl amazonlinux-ami-custom.pkr.hcl &&
cd .. &&
terraform fmt &&
terraform plan &&
terraform apply -auto-approve
