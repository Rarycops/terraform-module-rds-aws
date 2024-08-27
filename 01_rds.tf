resource "aws_db_instance" "db_instance" {
  instance_class                  = var.db_instance_instance_class
  replicate_source_db             = var.db_instance_replicate_source_db
  snapshot_identifier             = var.db_instance_snapshot_identifier
  allocated_storage               = var.db_instance_allocated_storage
  allow_major_version_upgrade     = var.db_instance_allow_major_version_upgrade
  apply_immediately               = var.db_instance_apply_immediately
  auto_minor_version_upgrade      = var.db_instance_auto_minor_version_upgrade
  availability_zone               = var.db_instance_availability_zone
  backup_retention_period         = var.db_instance_backup_retention_period
  backup_target                   = var.db_instance_backup_target
  backup_window                   = var.db_instance_backup_window
  ca_cert_identifier              = var.db_instance_ca_cert_identifier
  character_set_name              = var.db_instance_character_set_name
  copy_tags_to_snapshot           = var.db_instance_copy_tags_to_snapshot
  custom_iam_instance_profile     = var.db_instance_custom_iam_instance_profile
  db_name                         = var.db_instance_db_name
  db_subnet_group_name            = var.db_instance_db_subnet_group_name
  dedicated_log_volume            = var.db_instance_dedicated_log_volume
  delete_automated_backups        = var.db_instance_delete_automated_backups
  deletion_protection             = var.db_instance_deletion_protection
  domain                          = var.db_instance_domain
  domain_fqdn                     = var.db_instance_domain_fqdn
  domain_auth_secret_arn          = var.db_instance_domain_auth_secret_arn
  domain_dns_ips                  = var.db_instance_domain_dns_ips
  domain_iam_role_name            = var.db_instance_domain_iam_role_name
  domain_ou                       = var.db_instance_domain_ou
  enabled_cloudwatch_logs_exports = var.db_instance_enabled_cloudwatch_logs_exports
  engine                          = var.db_instance_engine
  engine_version                  = var.db_instance_engine_version
  engine_lifecycle_support        = var.db_instance_engine_lifecycle_support
  skip_final_snapshot             = var.db_instance_skip_final_snapshot
  final_snapshot_identifier       = var.db_instance_final_snapshot_identifier
  storage_encrypted               = var.db_instance_storage_encrypted
  storage_type                    = var.db_instance_storage_type
  dynamic "s3_import" {
    for_each = (
      var.db_instance_s3_import_bucket_name != null &&
      var.db_instance_s3_import_ingestion_role != null &&
      var.db_instance_s3_import_source_engine != null &&
      var.db_instance_s3_import_source_engine_version != null ? [1] : []
    )
    content {
      bucket_name           = var.db_instance_s3_import_bucket_name
      bucket_prefix         = var.db_instance_s3_import_bucket_prefix
      ingestion_role        = var.db_instance_s3_import_ingestion_role
      source_engine         = var.db_instance_s3_import_source_engine
      source_engine_version = var.db_instance_s3_import_source_engine_version
    }
  }
  dynamic "restore_to_point_in_time" {
    for_each = (
      var.db_instance__restore_to_point_in_time_restore_time != null ||
      var.db_instance__restore_to_point_in_time_source_db_instance_identifier != null ||
      var.db_instance__restore_to_point_in_time_source_db_instance_automated_backups_arn != null ||
      var.db_instance__restore_to_point_in_time_source_dbi_resource_id != null ||
      var.db_instance__restore_to_point_in_time_use_latest_restorable_time != null ? [1] : []
    )
    content {
      restore_time                             = var.db_instance__restore_to_point_in_time_restore_time
      source_db_instance_identifier            = var.db_instance__restore_to_point_in_time_source_db_instance_identifier
      source_db_instance_automated_backups_arn = var.db_instance__restore_to_point_in_time_source_db_instance_automated_backups_arn
      source_dbi_resource_id                   = var.db_instance__restore_to_point_in_time_source_dbi_resource_id
      use_latest_restorable_time               = var.db_instance__restore_to_point_in_time_use_latest_restorable_time
    }
  }
  blue_green_update {
    enabled = var.db_instance_blue_green_update_enabled
  }
}
