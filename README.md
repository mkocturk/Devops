# DigitalOcean Infrastructure with Terraform

This project contains Terraform configurations for deploying and managing infrastructure on DigitalOcean, including Droplets and firewalls.

## Infrastructure Components

- **Droplet**: Ubuntu-based virtual machine with Docker pre-installed
- **Firewall**: Basic firewall configuration for the Droplet
- **Tags**: Comprehensive tagging system for resource organization

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (version >= 1.0.0)
- [DigitalOcean Account](https://cloud.digitalocean.com/registrations/new)
- DigitalOcean API Token
- SSH Key pair for Droplet access

## Configuration

### Environment Variables

```bash
export TF_VAR_do_token="your-digitalocean-api-token"
export TF_VAR_ssh_keys='["your-ssh-key-fingerprint"]'
```