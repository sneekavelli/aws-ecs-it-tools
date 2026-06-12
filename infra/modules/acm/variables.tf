variable "project_name" {
  type        = string
  description = "The prefix name for your resources"
}

variable "domain_name" {
  type        = string
  description = "The primary domain name (e.g., it-tools.humblehotheads.com)"
}

variable "subject_alternative_names" {
  type        = list(string)
  default     = []
  description = "Any extra subdomains you want to include"
}

variable "zone_id" {
  type        = string
  description = "The Route 53 Hosted Zone ID for your domain"
}