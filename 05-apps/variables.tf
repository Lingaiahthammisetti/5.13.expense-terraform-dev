variable "common_tags" {
    type = map
    default = {
        Terraform = "true"
        Environment = "Dev"
        Project = "expense"
    }
}
variable "environment" {
   default =  "dev"
}

variable  "project_name" {
  default = "expense"
}

variable "zone_name" {
  default = "lingaiah.online"
}