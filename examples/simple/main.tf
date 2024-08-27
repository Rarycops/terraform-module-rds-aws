module "RDS" {
  source = "../../"

  db_instance_instance_class    = "t4g.nano"
  db_instance_allocated_storage = 5
}
