# gcloud
[back](https://stavbensimchon.github.io/lab)

- help (https://cloud.google.com/sdk/docs/cheatsheet)

```bash


gcloud init

gcloud auth activate-service-account test-service-account@google.com --key-file=/path/key.json --project=testproject

gcloud auth login [email | account]

gcloud projects list

gcloud config set project molten-reach-287514

gcloud auth configure-docker

gcloud container clusters get-credential

gcloud compute zones list

gcloud compute regions list


```

```bash
gcloud projects create ${TF_ADMIN} \
  --organization ${TF_VAR_org_id} \
  --set-as-default

gcloud beta billing projects link ${TF_ADMIN} \
  --billing-account ${TF_VAR_billing_account}


gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com


gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/billing.user


gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}

cat > backend.tf << EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_ADMIN}"
   prefix  = "terraform/state"
 }
}
EOF

gsutil versioning set on gs://${TF_ADMIN}

# project.tf
variable "project_name" {}
variable "billing_account" {}
variable "org_id" {}
variable "region" {}

provider "google" {
  region = var.region
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  org_id          = var.org_id
}

resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com"
  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

output "project_id" {
  value = google_project.project.project_id
}

# compute.tf
data "google_compute_zones" "available" {
  project = google_project.project.project_id
}

resource "google_compute_instance" "default" {
  project      = google_project.project.project_id
  zone         = data.google_compute_zones.available.names[0]
  name         = "tf-compute-1"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20170328"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  depends_on = [google_project_service.service]
}

output "instance_id" {
  value = google_compute_instance.default.self_link
}

export TF_VAR_project_name=${USER}-test-compute
export TF_VAR_region=us-central1

terraform init
terraform plan
terraform apply [-auto-approve]

export instance_id=$(terraform output instance_id)
export project_id=$(terraform output project_id)

gcloud compute ssh ${instance_id} --project ${project_id}

terraform destroy

gcloud projects delete ${TF_ADMIN}

gcloud organizations remove-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations remove-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/billing.user
```