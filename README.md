# DigitalOcean Terraform Configuration

Bu proje DigitalOcean'da Terraform kullanarak VM (Droplet) oluşturmak için gerekli konfigürasyonları içerir.

## Ön Gereksinimler

- [Terraform](https://www.terraform.io/downloads.html) (en son versiyon)
- [DigitalOcean Account](https://cloud.digitalocean.com/registrations/new)
- DigitalOcean API Token
- SSH Key

## Kurulum

1. Repo'yu klonlayın:
```bash
git clone <repo-url>
cd <repo-directory>
```

2. Environment variables'ları ayarlayın:
```bash
export TF_VAR_do_token="your-digitalocean-api-token"
export TF_VAR_ssh_key_fingerprint="your-ssh-key-fingerprint"
```

3. Terraform'u başlatın:
```bash
terraform init
terraform plan
terraform apply
```

## Değişkenler

| Değişken | Açıklama |
|----------|-----------|
| do_token | DigitalOcean API Token |
| droplet_name | VM adı |
| droplet_region | Bölge (örn: fra1) |
| droplet_size | VM boyutu (örn: s-1vcpu-1gb) |
| ssh_key_fingerprint | SSH key fingerprint |

## Güvenlik Notları

- API token'ı asla GitHub'a commit etmeyin
- Hassas bilgileri environment variable olarak saklayın
- `.env` dosyasını `.gitignore`'a ekleyin

## Temizlik

Kaynakları silmek için:
```bash
terraform destroy
```