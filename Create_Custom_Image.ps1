#General Tips 
    # use Ctrl-F2 to rename every instance 
    # Select and press F8 to run only the selected code 
    #Investigate any failure w/ the Portal Event / Activity Log 
    
#Generalizing and creating a custom image using PowerShell
#Setup - pre-stage the RDP connection for the Windows VM - 'vm-Demo'
#Ensure we're in the PowerShell Integrated Console.

#You can use Azure CLI or PowerShell on Windows or Linux Systems.

#Ensure that the Azure Module is installed on your computer's Powershell
Install-Module Az -Force -AllowClobber

#Start a connection with Azure
# Connect-AzAccount -SubscriptionName 'Demonstration Account'

#Open and RDP session to this Windows VM and copy/paste and run this command in a command prompt. 
#This will Generalize the VM and shut it down.
#Use vm-Demo for this demo.  
%WINDIR%\system32\sysprep\sysprep.exe /generalize /shutdown /oobe

#Let's get the status of our VM and ensure it's stopped first.
Get-AzVM `
    -ResourceGroupName 'rg-Demo1' `
    -Name 'vm-Demo1' `
    -Status 

#Find our Resource Group
$rg = Get-AzResourceGroup `
    -Name 'rg-Demo' `
    -Location 'East US'

#Find our VM in our Resource Group
$vm = Get-AzVm `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name "vm-Demo"

#Deallocate the virtual machine
Stop-AzVM `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name $vm.Name `
    -Force

#Check the status of the VM to see if it's deallocated
Get-AzVM `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name $vm.Name `
    -Status 

#Mark the virtual machine as "generalized"
Set-AzVM `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name $vm.Name `
    -Generalized

#Start an Image Configuration from our source Virtual Machine $vm
$image = New-AzImageConfig `
    -Location $rg.Location `
    -SourceVirtualMachineId $vm.ID

#Create a VM image from the custom image config we just created, simply specify the image config as a source.
New-AzImage `
    -ResourceGroupName $rg.ResourceGroupName `
    -Image $image `
    -ImageName "ci-Demo"

#Summary image information. You'll see two images, one Linux and on Windows.
#The linux image is from the Azure CLI example.
Get-AzImage `
    -ResourceGroupName $rg.ResourceGroupName

#Create user object, this will be used for the Windows username/password
$password = ConvertTo-SecureString 'Winter2019))' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ('emathur', $password)

#Let's create a VM from our new image, we'll use a more terse definition for this VM creation
New-AzVm `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name "vm-Demo-PS" `
    -ImageName "vm-Demo-CustomImage" `
    -Location 'East US' `
    -Credential $WindowsCred `
    -VirtualNetworkName 'rg-Demo-vnet' `
    -SubnetName 'rg-Demo-subnet' `
    -SecurityGroupName 'vm-Demo' `
    -OpenPorts 3389 `
    -verbose

#Check out the status of our provisioned VM from the Image
Get-AzVm `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name "vm-Demo-ImageCopy"

#You can delete the deallocated source VM
Remove-AzVm `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name "vm-Demo" `
    -Force

#And that still leaves the image in our Resource Group
Get-AzImage `
    -ResourceGroupName $rg.ResourceGroupName `
    -ImageName 'vm-Demo-CustomImage'
