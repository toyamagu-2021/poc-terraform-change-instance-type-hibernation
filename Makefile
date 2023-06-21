.PHONY: start
start:
	terraform init
	terraform apply -var-file="1st.tfvars"
