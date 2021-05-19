terraform {
  required_version = ">= 0.12"

  required_providers {
    google = {
      source = "hashicorp/google"
    }

    gitlab = {
      source = "gitlabhq/gitlab"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

  }
}
