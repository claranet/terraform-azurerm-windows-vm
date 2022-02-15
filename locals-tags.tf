locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}

  default_vm_tags = var.default_tags_enabled ? {
    os_family       = "windows"
    os_distribution = lookup(var.vm_image, "offer", "undefined")
    os_version      = lookup(var.vm_image, "sku", "undefined")
  } : {}
}
