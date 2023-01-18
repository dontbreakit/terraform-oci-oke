# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  worker_image_id = (length(var.worker_group_image_id) > 0 ? var.worker_group_image_id
  : var.node_pool_image_id != "none" ? var.node_pool_image_id : "")
  worker_image_type = (length(var.worker_group_image_type) > 0 ? var.worker_group_image_type
  : var.node_pool_image_type != "none" ? var.node_pool_image_type : "")
}

# Default workergroup sub-module implementation for OKE cluster
module "workergroup" {
  source                          = "./modules/workergroup"
  state_id                        = random_id.state_id.id
  config_file_profile             = var.config_file_profile
  worker_groups                   = var.worker_groups
  tenancy_id                      = local.tenancy_id
  compartment_id                  = local.worker_compartment_id
  region                          = var.region
  cluster_id                      = coalesce(var.cluster_id, one(module.oke[*].cluster_id))
  cni_type                        = var.cni_type
  apiserver_private_host          = try(split(":", module.oke[0].endpoints[0].private_endpoint)[0], "")
  apiserver_public_host           = try(split(":", module.oke[0].endpoints[0].public_endpoint)[0], "")
  image_id                        = local.worker_image_id
  image_type                      = local.worker_image_type
  os                              = var.node_pool_os
  os_version                      = var.node_pool_os_version
  enabled                         = var.worker_group_enabled
  mode                            = var.worker_group_mode
  boot_volume_size                = var.worker_group_boot_volume_size
  memory                          = var.worker_group_memory
  ocpus                           = var.worker_group_ocpus
  shape                           = var.worker_group_shape
  size                            = var.worker_group_size
  cloudinit                       = var.cloudinit_nodepool_common
  enable_pv_encryption_in_transit = var.enable_pv_encryption_in_transit
  cluster_ca_cert                 = var.cluster_ca_cert
  kubernetes_version              = var.kubernetes_version
  pod_nsgs                        = try(split(",", lookup(module.network.nsg_ids, "pods", "")), [])
  worker_nsgs                     = coalescelist(var.worker_nsgs, try(split(",", lookup(module.network.nsg_ids, "workers", "")), []))
  assign_public_ip                = var.worker_type == "public"
  subnet_id                       = coalesce(var.worker_group_subnet_id, lookup(module.network.subnet_ids, "workers", ""))
  sriov_num_vfs                   = var.sriov_num_vfs
  ssh_public_key                  = var.ssh_public_key
  ssh_public_key_path             = var.ssh_public_key_path
  timezone                        = var.node_pool_timezone
  volume_kms_key_id               = var.node_pool_volume_kms_key_id
  label_prefix                    = var.label_prefix
  defined_tags                    = lookup(lookup(var.defined_tags, "oke", {}), "node", {})
  freeform_tags                   = lookup(lookup(var.freeform_tags, "oke", {}), "node", {})
  allow_autoscaler                = var.allow_autoscaler
  autoscale                       = var.autoscale
  providers = {
    oci.home = oci.home
  }
}
