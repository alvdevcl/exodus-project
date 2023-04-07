# terraform {
#   required_providers {
#     aws = {
#       version = "3.55.0"
#       source  = "hashicorp/aws"

#     }

#     tls = {
#       version = "3.1.0"
#       source  = "hashicorp/tls"
#     }

#     http = {
#       version = "2.1.0"
#       source  = "hashicorp/http"
#     }
#   }
#   required_version = ">=0.14.8"
# }


terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.17"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = ">= 0.1.2"
    }

    tls = {
      version = "3.1.0"
      source  = "hashicorp/tls"
    }

    http = {
      version = "2.1.0"
      source  = "hashicorp/http"
    }
  }

}