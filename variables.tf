# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
}

variable "admin_username" {
  description = "The admin username for the VM being created."
  default = "Anvesh"
}

variable "admin_password" {
  description = "The password for the VM being created."
  default = "Anvesh"
}

variable "resource_group" {
  description = "resourcegroup"
  default = "AzureDevops"
}

variable "packer_image_name" {
  description = "Name of the Packer image"
  default     = "myPackerImage"
}
variable "vm_count" {
  description = "No. of vms to deploy"
  default     = "1"
}
