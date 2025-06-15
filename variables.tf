# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "subscription_id" {
  description = "The Azure subscription_id which all resources will be utilized."
}

variable "source_image_id" {
  description = "The Image ID that was produced from Packer build."
  }

variable "admin_username" {
  description = "The admin username for the VM being created."
  default = "Anvesh"
}

variable "admin_password" {
  description = "The password for the VM being created."
  default = "Anvesh@123"
}

variable "packer_image_name" {
  description = "Name of the Packer image"
  default     = "AnveshprojectImage"
}
variable "vm_count" {
  description = "No. of vms to deploy. min is 2 and max is 5"
  default = 2
  validation {
    condition     = var.vm_count > 1 && var.vm_count < 6
    error_message = "The vm_count value must be at least 2, and for cost reasons, no more than 5."
  }
}
variable "common_tags" {
  type = map(string)
  default = {
    Project = "Udacity-deployment-project"
  }
}


