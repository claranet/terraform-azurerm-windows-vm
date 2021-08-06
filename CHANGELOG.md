# Unreleased

Changed
  * AZ-546: CLean module, remove unused variables

# v4.1.2 - 2021-06-11

Added
  * AZ-508: Add `source_image_id` as a mutex of `source_image_reference`

# v4.1.1 - 2021-06-08

Fixed
  * AZ-505: Fix variable type for `storage_data_disk_config`

# v4.1.0 - 2021-01-15

Changed
  * AZ-398: Force lowercase on default generated name

# v3.2.1/v4.0.0 - 2020-11-19

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

# v3.2.0 - 2020-11-17

Added
  * AZ-333: Add custom tags on Nic, Pub IP and os disk
  * AZ-322: Allow retrieving certificates from Key Vault

# v3.1.0 - 2020-10-16

Added
  * AZ-308: Backup configuration options

# v3.0.1 - 2020-10-05

Fixed
  * AZ-234: Fix `custom_ipconfig_name` variable with default null value

# v3.0.0 - 2020-07-30

Breaking
  * AZ-198: Upgrade AzureRM 2.0

Changed
  * AZ-209: Update CI with Gitlab template

# v2.4.0 - 2020-07-29

Added
  * AZ-234: Add option to force Static private IP
  * AZ-234: Add option to associate Network Security Group to the NIC
  * AZ-234: Output NIC ID
  * AZ-222: Option to activate `enable_accelerated_networking` on NIC resource

Fixed
  * AZ-167: Fix NIC configuration name

# v2.3.1 - 2020-07-09

Changed
  * AZ-206: Pin AzureRM version to be usable < 2.0

# v2.3.0 - 2020-04-30

Added
  * AZ-210: Enabled unmanaged disk configuration

# v2.2.0 - 2020-02-18

Added
  * AZ-162: Log Analytics Workspace link
  * AZ-174: Add Availability Zone option 
  * AZ-180: Additional default tags

# v2.1.0 - 2019-12-18

Added
  * AZ-135: Allow to change IP sku and attach to a Load Balancer or Application Gateway 
  * AZ-119: Add CONTRIBUTING.md doc and `terraform-wrapper` usage with the module
  * AZ-161: Allow to configure license-type

Changed
  * AZ-119: Revamp README for public release

# v2.0.1 - 2019-12-17

Fixed
  * AZ-153: Fix XML Password containing special chars

# v2.0.0 - 2019-09-06

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

Added
  * AZ-113: Enable diagnostics settings
  * AZ-118: Add LICENSE, NOTICE & Github badges

# v0.1.0 - 2019-07-12

Added
  * AZ-103: First Release
