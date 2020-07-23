# Terraform module for GCP Domain Verification

Simple module that'll bring up an nginx instance to verify your domain in a GCP Project.

<!-- toc -->

## Variables required

Key | Value
-|-
`network` | Network that houses the instance
`subnetwork` | Subnetwork that houses the instance
`region` | Region that houses the instance
`dns_zone` | DNS zone to verify
`dns_zone_name` | Name of the DNS zone to verify
`labels` | Labels to apply
`verification_file` | Verification file supplied by GCP

## Licensing

 * [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0): [`./LICENSE-APACHE`](LICENSE-APACHE)
 * [MIT License](https://opensource.org/licenses/MIT): [`./LICENSE-MIT`](LICENSE-MIT)

Licensed at your option of either of the above licenses.
