# GCP Infrastructure

Using Terraform as the configuration management tool to build the declared GCP Landing Zone Estate


## AWS Landing Zone

- VPC - Public Subnets & Private Subnets
- IP Route Table with Internet Gateway
- GKE Cluster and Node / Worker Group
- GKE Cluster Permissions for GitLab Integration
- Terraform state managed via GitLab TF State management

```
├── gitlab-admin.tf     # Adding kubernetes service account
├── gke.tf              # Google GKE Configuration
├── project-cluster.tf  # Registering kubernetes cluster to GitLab `project` Group
├── versions.tf         # Terraform providers list
└── vpc.tf              # GPC Landing Zone
```

# Set up

GCP credentials (IAM Service Account) is required to run the Terraform executions

 Below is an example on how to import the IAM (json key) into the run time
 
```
export TF_CREDS=gcp-tf-sa.json
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS} 
```