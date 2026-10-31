# PowerShell-Azure

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?logo=powershell&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)

> **Summary:** PowerShell scripts that automate the Azure VM lifecycle — from generalizing a VM and building a reusable custom image, to creating and removing VMs with splatting.

Azure VM automation with PowerShell: build a generalized custom image from a VM, and create or remove VMs with splatting.

## What it does

- Builds a generalized custom image from an existing Windows VM, so new VMs can be provisioned from it.
- Creates Windows VMs from a custom image using PowerShell splatting, looks up the VM's public IP, and tears the resource group down when done.
- Prompts for credentials securely at runtime with `Get-Credential` — nothing secret is stored in the scripts.

## Scripts

- **Create_Custom_Image.ps1** — Sysprep/generalize a Windows VM, deallocate it, mark it generalized, and build a reusable custom image from it.
- **Create_Remove_VM.ps1** — Create a Windows VM from a custom image using splatting, look up its public IP, and tear the resource group down when done.

| Script | Workflow |
| --- | --- |
| `Create_Custom_Image.ps1` | Sysprep/generalize a Windows VM → deallocate it → mark it generalized → build a reusable custom image |
| `Create_Remove_VM.ps1` | Create a Windows VM from a custom image using splatting → look up its public IP → remove the resource group when done |

## How to use

1. Install the Az module and sign in to Azure:
   ```powershell
   Install-Module Az
   Connect-AzAccount
   ```
2. Open a script and replace the example names (resource group, VM, location, image) with your own values.
3. Run the script from top to bottom — each script is written as a series of steps.
4. When prompted, enter the VM administrator credentials via `Get-Credential`. Do not hardcode passwords.

## Prerequisites

- PowerShell with the `Az` module (`Install-Module Az`)
- An Azure subscription — connect first with `Connect-AzAccount`

## Security note

Credentials are prompted securely at runtime with `Get-Credential`. No passwords or secrets are stored in these scripts.
