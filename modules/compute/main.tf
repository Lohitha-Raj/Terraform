resource "azurerm_network_interface" "nic" {
  for_each = toset(var.vm_names)

  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = toset(var.vm_names)

  name                = each.key
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B1s"

  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # 🔥 NGINX INSTALLATION
  custom_data = base64encode(<<EOF
#!/bin/bash
apt update -y
apt install -y nginx

echo "Hello from $(hostname)" > /var/www/html/index.html

systemctl enable nginx
systemctl start nginx
EOF
  )
}