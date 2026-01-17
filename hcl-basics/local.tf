resource "local_file" "pet" {         # resource ---> is a block,  local_file -----> is a resource_type.
     filename = "hcl-basics/temp.txt "
     content = "I am learning terraform"
}


