# HCL Basics

### **What is HCL (HashiCorp Configuration Language)?**
  - HCL stands for HashiCorp Configuration Language, which is a decalrative langugage allow to provision cloud and on-premise infrastructure in a automated manner.
  

### HCL syntax

  ```bash
   <block> <parameters> {
     key1= value1
     key2 = value2
   }
  ```

  Example: 

```bash
  resource <provider_type> <name> {
    config...
  }
```

## What is .terraform.lock.hcl file?

- The .terraform.lock.hcl file is a dependency lock file used by Terraform to record the exact versions and cryptographic checksums of the provider plugins used in a project. 


## What does `terraform init` command do?

- It check the configuration file and initializes the working directory containing the .tf file. 
- This command understand that we are making use of particular provider based on the resource type declared in the resource block.
- It will download the plugin to be able to work on resources declared in the .tf file.
- It will download and install plugin for specific provider.
- It will also show plugin version.


