## 7.11.2 (2025-09-18)

### Code Refactoring

* **tagging:** ♻️ replace outdated tagging module `with azapi_resource_action` 7f982e1, closes #7

## 7.11.1 (2025-04-08)

### Bug Fixes

* disable bypass_platform_safety_checks_on_user_schedule_enabled when hotpatching_enabled is true b0e51c0, closes #4

### Miscellaneous Chores

* **ci:** enable release on `legacy/v7` branch 7435c33
* **deps:** update dependency claranet/tagging/azurerm to v6.0.2 e8cb078
* **deps:** update dependency opentofu to v1.8.3 fc10bae
* **deps:** update dependency opentofu to v1.8.4 7f9622e
* **deps:** update dependency opentofu to v1.8.6 a096d15
* **deps:** update dependency opentofu to v1.8.8 57c2840
* **deps:** update dependency pre-commit to v4 b783587
* **deps:** update dependency pre-commit to v4.0.1 3f52c87
* **deps:** update dependency tflint to v0.54.0 1434746
* **deps:** update dependency trivy to v0.56.1 3a7e99e
* **deps:** update dependency trivy to v0.56.2 2bd24b0
* **deps:** update dependency trivy to v0.57.1 755c9f6
* **deps:** update dependency trivy to v0.58.1 599f639
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 c6f66f3
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 12c8c54
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 ba9d896
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 21bdffd
* **deps:** update tools d01081b
* **deps:** update tools c56a5d5
* pin release for `legacy/v7` branch 51757d6
* prepare for new examples structure eb1421d
* update examples structure 67cba58

## 7.11.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider 2c7bac7

### Documentation

* update README badge to use OpenTofu registry 13f64b8
* update README with `terraform-docs` v0.19.0 370fd35

### Miscellaneous Chores

* **deps:** update dependency terraform-docs to v0.19.0 4752ce7
* **deps:** update dependency trivy to v0.55.2 8113c62
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 df2766c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 9015ec6

## 7.10.0 (2024-09-13)

### Features

* **AZ-1453:** add user assigned identity to AMA settings 16fb1a2

### Miscellaneous Chores

* **AZ-1453:** fix regression on identities 61b38fd
* **AZ-1453:** handle all combinaison for identity type 536807b
* **AZ-1453:** improve for_each syntax 11eb060
* **deps:** update dependency opentofu to v1.7.3 49b44a7
* **deps:** update dependency opentofu to v1.8.0 a529cfb
* **deps:** update dependency opentofu to v1.8.1 a29ab86
* **deps:** update dependency opentofu to v1.8.2 9c35c72
* **deps:** update dependency pre-commit to v3.8.0 b9bc59e
* **deps:** update dependency tflint to v0.51.2 c542160
* **deps:** update dependency tflint to v0.52.0 dfa3f56
* **deps:** update dependency trivy to v0.53.0 a959b28
* **deps:** update dependency trivy to v0.54.1 561ba53
* **deps:** update dependency trivy to v0.55.0 c8aca15
* **deps:** update dependency trivy to v0.55.1 300372d
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 aa42ca6
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 7802ce1
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 ab8a71b
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 6d8e07c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 ab54b19
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 10f6fd7
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 2bd25d4
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 208763a
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 dbd2464
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 f66884c
* **deps:** update terraform claranet/regions/azurerm to ~> 7.2.0 7cadc6c
* **deps:** update tools 3383cd4

## 7.9.2 (2024-06-21)


### ⚠ BREAKING CHANGES

* changes introduced with AzureRM provider `v3.108.0`

### Code Refactoring

* rename `nic_enable_accelerated_networking` to `nic_accelerated_networking_enabled` f34e7f6


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.0 aadc4f2
* **deps:** update dependency opentofu to v1.7.1 dd9c2cd
* **deps:** update dependency opentofu to v1.7.2 f6333f0
* **deps:** update dependency pre-commit to v3.7.1 cac101f
* **deps:** update dependency terraform-docs to v0.18.0 560f233
* **deps:** update dependency tflint to v0.51.0 f8ae3c8
* **deps:** update dependency tflint to v0.51.1 0339f03
* **deps:** update dependency trivy to v0.50.4 e13d280
* **deps:** update dependency trivy to v0.51.0 5b50f1f
* **deps:** update dependency trivy to v0.51.1 18a8226
* **deps:** update dependency trivy to v0.51.2 5e1a83e
* **deps:** update dependency trivy to v0.51.4 3d01892
* **deps:** update dependency trivy to v0.52.0 e7a0eef
* **deps:** update dependency trivy to v0.52.1 6531d2e
* **deps:** update dependency trivy to v0.52.2 f816734
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 4bac02d

## 7.9.1 (2024-04-26)


### Styles

* **output:** remove unused version from outputs-module 80c82c1


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 505b093
* **AZ-1391:** update semantic-release config [skip ci] bee4360


### Miscellaneous Chores

* **deps:** add renovate.json b1bb937
* **deps:** enable automerge on renovate ab5db3e
* **deps:** update dependency trivy to v0.50.2 ed0bc1b
* **deps:** update renovate.json b97ddc8
* **deps:** update terraform claranet/regions/azurerm to v7 7042894
* **pre-commit:** update commitlint hook 77a6d41
* **release:** remove legacy `VERSION` file 1295b8d

# v7.9.0 - 2024-02-02

Added
  * AZ-1342: Add `encryption_at_host_enabled` parameter

# v7.8.2 - 2024-01-19

Fixed
  * [GH-2](https://github.com/claranet/terraform-azurerm-windows-vm/issues/2): Update example and README about AAD groups usage for VM sso login.

# v7.8.1 - 2023-09-29

Fixed
  * AZ-1186: Fix Key Vault certificate reference

# v7.8.0 - 2023-09-15

Changed
  * AZ-1052: Improved legacy agent configuration

# v7.7.0 - 2023-09-08

Added
  * AZ-1122: Adding the possibility to disable the WinRM deployment with `key_vault_id` variable to null

Changed
  * AZ-1165: Change `bypass_platform_safety_checks_on_user_schedule_enabled` implementation from azapi provider to native azurerm

# v7.6.0 - 2023-08-18

Changed
  * AZ-1052 : Resync with `linux-vm`
    * `storage_os_disk_config` is now `os_disk_caching`, `os_disk_size_gb`,  `os_disk_storage_account_type`
    * `log_analytics_agent_enabled` is now disabled by default
    * `azure_monitor_agent_version` upgrade to 1.13
    * `identity` parameter, will remove systemassigned identity if not configured
    * if patchmode is AutomaticByPlatform configure needed flag

Added
  * AZ-1052 :
    * `vm_plan` parameter
    * `custom_data` parameter
    * `spot_instance`, `spot_instance_eviction_policy`, `spot_instance_max_bid_price` parameters

# v7.5.1 - 2023-06-16

Fixed
  * AZ-1102: Fix the managed data disks zone parameter if the storage type is `ZRS`

# v7.5.0 - 2023-03-03

Changed
  * AZ-1019: Bump `os_tagging` module
  * AZ-1018: Added `name_suffix` to storage disk default naming

# v7.4.0 - 2023-02-03

Added
  * AZ-837: Add maintenance configuration attachment option

# v7.3.0 - 2022-11-24

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v7.2.0 - 2022-11-04

Fixed
  * AZ-883: Lint code, fix deprecated HCL syntax

Added
  * AZ-895: Add output `vm_hostname`
  * AZ-857: Support for `user-data`

# v7.1.0 - 2022-10-07

Breaking
  * AZ-870: Allow more than 15 characters on VM resource name, keep it for hostname

# v7.0.1 - 2022-10-07

Fixed
  * AZ-859: Add requirements for new patch management (preview)

# v7.0.0 - 2022-09-30

Breaking
  * AZ-840: Update to Terraform `1.3`

Added
  * AZ-845: Add `patch_mode` and `hotpatching_enabled` options
  * AZ-845: Set `patch_assessment_mode` to `AutomaticByPlatform` when `path_mode` is also set to `AutomaticByPlatform`

# v6.2.0 - 2022-09-16

Added
  * AZ-807: Custom name for Data Collection Rule link resource

# v6.1.0 - 2022-09-12

Changed
  * AZ-838: Change `storage_os_disk_config.storage_account_type` attribute default value to `Premium_ZRS`
  * AZ-838: Bump Azure Monitor extension version to latest `v1.7.0.0` (July 2022, for reference: https://docs.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-extension-versions)
  * AZ-807: Use native resource for Data Collection Rule link

Added
  * AZ-838: Add `custom_computer_name` variable (customize Windows hostname)
  * AZ-838: Add tags on deployed VM extensions and add `extensions_extra_tags` parameter
  * AZ-833: Add AADLogin capability

# v6.0.2 - 2022-07-29

Fixed
  * AZ-810: Fix os disk datasource which don't find disks with custom name

# v6.0.1 - 2022-06-24

Added
  * AZ-770: Add Terraform module info in output

# v6.0.0 - 2022-05-18

Breaking
  * AZ-717: Bump module for AzureRM provider `v3.0+`

# v5.0.0 - 2022-02-15

Added
  * AZ-615: Add an option to enable or disable default tags

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

Changed
  * AZ-610: Optional OS disk tagging

# v4.4.0 - 2021-11-24

Added
  * AZ-608: Add variable `azure_monitor_agent_auto_upgrade_enabled`

Changed
  * AZ-606: Remove VM Tags on disk
  * AZ-608: Change provider min version to 2.83. `automatic_upgrade_enabled` option was implemented in this version in `azurerm_virtual_machine_extension`

# v4.3.0 - 2021-10-15

Breaking
  * AZ-302: Replace diagnostics agent with Azure Monitor agent

Changed
  * AZ-572: Revamp examples and improve CI
  * AZ-302: Bump Log Analytics agent version to latest and allow override

# v4.2.1 - 2021-08-27

Fixed
  * AZ-532: Revamp README with latest `terraform-docs` tool

# v4.2.0 - 2021-08-06

Added
  * AZ-509: Add managed data disk

Changed
  * AZ-546: Clean module, remove unused variables

Fixed
  * AZ-510: Fix creation condition for keyvault extension

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
