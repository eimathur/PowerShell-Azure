# PowerShell-Azure

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?logo=powershell&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)

Azure VM automation with PowerShell: build a generalized custom image from a VM, and create or remove VMs with splatting.

## Scripts

- **Create_Custom_Image.ps1** — Sysprep/generalize a Windows VM, deallocate it, mark it generalized, and build a reusable custom image from it.
- **Create_Remove_VM.ps1** — Create a Windows VM from a custom image using splatting, look up its public IP, and tear the resource group down when done.

## Prerequisites

- PowerShell with the `Az` module (`Install-Module Az`)
- An Azure subscription — connect first with `Connect-AzAccount`

## Security note

Credentials are prompted securely at runtime with `Get-Credential`. No passwords or secrets are stored in these scripts.
