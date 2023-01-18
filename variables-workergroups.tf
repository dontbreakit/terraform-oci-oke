# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "worker_group_enabled" {
  default     = true
  description = "Default for whether to apply resources for a group"
  type        = bool
}

variable "worker_group_mode" {
  default     = "node-pool"
  description = "Default management mode for worker groups when unspecified"
  type        = string
  validation {
    condition     = contains(["node-pool", "instance-pool", "cluster-network"], var.worker_group_mode)
    error_message = "Accepted values are node-pool, instance-pool, or cluster-network"
  }
}

variable "cluster_dns" {
  default     = "10.96.5.5"
  description = "Cluster DNS resolver IP address"
  type        = string
}

variable "cluster_id" {
  default     = ""
  description = "The OKE cluster ID to which nodes in a worker group should join on startup. Discovered automatically for a cluster managed in the same Terraform state."
  type        = string
}

variable "cluster_ca_cert" {
  default     = ""
  description = "Cluster CA certificate. Required for Self-managed instance pools for secure control plane connection."
  type        = string
}

variable "sriov_num_vfs" {
  default     = 1
  description = "Number of SR-IOV virtual functions to create for each physical function on Mellanox NICs when present. 0 to disable."
  type        = number
}

variable "worker_group_boot_volume_size" {
  default     = 50
  description = "Default size in GB for the boot volume of created worker nodes"
  type        = number
}

variable "worker_groups" {
  default     = {}
  description = "Tuple of OKE worker groups where each key maps to the OCID of an OCI resource, and value contains its definition"
  type        = any
}

variable "worker_group_size" {
  default     = 0
  description = "Default size for worker groups when unspecified"
  type        = number
}

variable "worker_group_image_id" {
  default     = ""
  description = "Default image for worker groups when unspecified"
  type        = string
}

variable "worker_group_shape" {
  default     = "VM.Standard.E4.Flex"
  description = "Default shape for instance pools when undefined"
  type        = string
}

variable "worker_group_ocpus" {
  description = "Default ocpus for flex shapes"
  default     = 1
  type        = number
}

variable "worker_group_memory" {
  default     = 16
  description = "Default memory in GB for flex shapes"
  type        = number
}

variable "worker_group_image_type" {
  default     = "custom"
  description = "Whether to use a Platform, OKE or custom image. When custom is set, the worker_group_image_id must be specified."
  type        = string
  validation {
    condition     = contains(["custom", "oke", "platform"], var.worker_group_image_type)
    error_message = "Accepted values are custom, oke, platform"
  }
}

variable "worker_group_subnet_id" {
  default     = ""
  description = "The subnet OCID used for instances"
  type        = string
}

variable "worker_group_cloudinit" {
  default     = ""
  description = "Base64-encoded cloud init script to run on worker node boot"
  type        = string
}

variable "allow_autoscaler" {
  default     = false
  description = "Whether to add node labels for scheduling of the Kubernetes Cluster Autoscaler on worker nodes with appropriate policies."
  type        = bool
}

variable "autoscale" {
  default     = false
  description = "Whether to enable autoscaling of worker groups with the Kubernetes Cluster Autoscaler, when enabled and schedulable."
  type        = bool
}
