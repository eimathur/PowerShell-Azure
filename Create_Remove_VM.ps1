#Let's create a Windows VM with a little less code...using PowerShell Splatting.

#When created a virtual network IP address space and subnet 
    #vnet 172.16.0.0/16 subnet 172.16.1.0/24

#Create PSCredential object, this will be used for the Windows username/password
$password = ConvertTo-SecureString 'Summer2000!@' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ('emathur', $password)



#We're using the Image parameter, for a list of images look here
#https://docs.microsoft.com/en-us/powershell/module/az.compute/new-azvm#parameters

#Use tab complete to help find your image name (or any other parameter), enter into the Terminal
       New-AzVM -Image       

#Size =====  
#D2s_v3 EastUS, vCPUs: 2, Ram: 8, MaxIOPS: 3200, Storage: 16GB, Cost/month: $70
#'Standard_B1ls' , 1vCPU,0.5GB Ram, $3.80
#==============
# There are no parameters for DiskName and NetworkInterface - they will be auto-generated 

$vmParams = @{
    ResourceGroupName = 'rg-Demo'
    Name = 'vm-Demo-ci'
    Location = 'East US'
    Size = 'Standard_D2s_v3'
    Image = 'ci-Demo'
    PublicIpAddressName = 'ip-Demo-ci'
    Credential = $WindowsCred
    VirtualNetworkName = 'vnet-Demo'
    SubnetName = 'subnet-Demo'
    SecurityGroupName = 'nsg-Demo'
    OpenPorts = 3389, 5589 
}
New-AzVM @vmParams -verbose 

Get-AzPublicIpAddress `
    -ResourceGroupName 'rg-Demo' `
    -Name 'ip-Demo' | Select-Object -ExpandProperty IpAddress

#Launch RDP session to new VM...

#Remove Resource Group 
Remove-AzResourceGroup `
    -Name 'rg-Demo' `
    -Force

