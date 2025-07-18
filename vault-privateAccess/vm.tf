resource "azurerm_public_ip" "main" {
  name                = "one-ip"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  allocation_method = "Static"

  tags = {
    component = "one-ip"
  }
}


resource "azurerm_public_ip" "main1" {
  name                = "second-ip"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  allocation_method = "Static"

  tags = {
    component = "one-ip"
  }
}


resource "azurerm_network_interface" "net" {
  name                = "example-nic"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = { for i in azurerm_virtual_network.main.subnet: i.name => i.id if i.name == "subnet1" }["subnet1"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_interface" "net1" {
  name                = "example-nic1"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = { for i in azurerm_virtual_network.main.subnet: i.name => i.id if i.name == "subnet2" }["subnet2"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main1.id
  }
}



resource "azurerm_linux_virtual_machine" "vm" {
  name                = "example-machine"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  disable_password_authentication = false
  admin_password                   = "Chaithanya1812"

  network_interface_ids = [
    azurerm_network_interface.net.id,
  ]

  os_disk {
    name                 = "sample"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # identity {
  #   type = "SystemAssigned"
  # }
  #
  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.example.id]
  # }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9-lvm-gen2"
    version   = "latest"
  }
}




resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "example-machine1"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  disable_password_authentication = false
  admin_password                   = "Chaithanya1812"

  network_interface_ids = [
    azurerm_network_interface.net1.id,
  ]

  os_disk {
    name                 = "sample1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # identity {
  #   type = "SystemAssigned"
  # }
  #
  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.example.id]
  # }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9-lvm-gen2"
    version   = "latest"
  }
}

output "ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "ip1" {
  value = azurerm_linux_virtual_machine.vm2.public_ip_address
}

output "details" {
  value = lookup({ for i in azurerm_virtual_network.main.subnet: i.name => i.id },"subnet1",null)
}

resource "null_resource" "main" {
  connection {
    type     = "ssh"
    user     = "azureuser"
    password = "Chaithanya1812"
    host     = azurerm_linux_virtual_machine.vm.public_ip_address
  }

  provisioner "file" {
    source      = "run.sh"
    destination = "/tmp/run.sh"
  }
  # triggers = {}
  provisioner "remote-exec" {
    # connection {
    #   type     = "ssh"
    #   user     = "azureuser"
    #   password = "Chaithanya1812"
    #   host     = azurerm_linux_virtual_machine.vm.public_ip_address
    # }
    inline = [
      "bash /tmp/run.sh",
      "az login --service-principal -u ${azuread_service_principal.sp.client_id} -p ${azuread_service_principal_password.pass.value} --tenant ${azuread_service_principal.sp.application_tenant_id}",
     # "az account show"
      # "sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm",
      # "sudo dnf install azure-cli -y"
      # "firewall-cmd --permanent --add-port=80/tcp",
      # "firewall-cmd --reload"
    ]
  }
}



resource "null_resource" "main1" {
  connection {
    type     = "ssh"
    user     = "azureuser"
    password = "Chaithanya1812"
    host     = azurerm_linux_virtual_machine.vm2.public_ip_address
  }

  provisioner "file" {
    source      = "run.sh"
    destination = "/tmp/run.sh"
  }


  provisioner "file" {
    content     =<<EOT
This is azure server
Helllo world this is
EOT
    destination = "/tmp/run1.sh"
  }

  # triggers = {}
  provisioner "remote-exec" {
    # connection {
    #   type     = "ssh"
    #   user     = "azureuser"
    #   password = "Chaithanya1812"
    #   host     = azurerm_linux_virtual_machine.vm.public_ip_address
    # }
    inline = [
      "bash /tmp/run.sh",
      "az login --service-principal -u ${azuread_service_principal.sp.client_id} -p ${azuread_service_principal_password.pass.value} --tenant ${azuread_service_principal.sp.application_tenant_id} --allow-no-subscriptions",
      # "az account show"
      # "sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm",
      # "sudo dnf install azure-cli -y"
      # "firewall-cmd --permanent --add-port=80/tcp",
      # "firewall-cmd --reload"
    ]
  }
}

















