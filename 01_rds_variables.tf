variable "db_instance_instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "db_instance_replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate (if replicating within a single region) or ARN of the Amazon RDS Database to replicate (if replicating cross-region)."
  type        = string
  default     = null
}

variable "db_instance_snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot."
  type        = string
  default     = null
}

variable "db_instance_allocated_storage" {
  description = "The allocated storage in gibibytes."
  type        = number
  validation {
    condition = (
      var.db_instance_snapshot_identifier == null && var.db_instance_replicate_source_db == null && var.db_instance_allocated_storage != null ||
      var.db_instance_allocated_storage == null && (var.db_instance_snapshot_identifier != null || var.db_instance_replicate_source_db != null)
    )
    error_message = "Required unless a snapshot_identifier or replicate_source_db is provided"
  }
  default = null
}

variable "db_instance_allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible."
  type        = bool
  default     = null
}

variable "db_instance_apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

variable "db_instance_auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type        = bool
  default     = true
}

variable "db_instance_availability_zone" {
  description = "The AZ for the RDS instance."
  type        = string
  default     = null
}

variable "db_instance_backup_retention_period" {
  description = "The days to retain backups for. Must be between 0 and 35. Default is 0."
  type        = number
  validation {
    condition     = var.db_instance_backup_retention_period >= 0
    error_message = "Must be greater than 0"
  }
  default = 0
}

variable "db_instance_backup_target" {
  description = "Specifies where automated backups and manual snapshots are stored. Possible values are 'region' (default) and 'outposts'."
  type        = string
  validation {
    condition     = var.db_instance_backup_target == "region" || var.db_instance_backup_target == "outposts"
    error_message = "The backup_target must be either 'region' or 'outposts'."
  }
  default = "region"
}

variable "db_instance_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: \"09:46-10:16\". Must not overlap with maintenance_window."
  type        = string
  default     = null
}

variable "db_instance_blue_green_update_enabled" {
  description = "Enables low-downtime updates when true."
  type        = bool
  default     = false
}

variable "db_instance_ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance."
  type        = string
  default     = null
}

variable "db_instance_s3_import_bucket_name" {
  description = "The bucket name where your backup is stored"
  type        = string
  default     = null
}

variable "db_instance_s3_import_bucket_prefix" {
  description = "Can be blank, but is the path to your backup"
  type        = string
  default     = null
}

variable "db_instance_s3_import_ingestion_role" {
  description = "Role applied to load the data."
  type        = string
  default     = null
}

variable "db_instance_s3_import_source_engine" {
  description = "Source engine for the backup"
  type        = string
  default     = null
}

variable "db_instance_s3_import_source_engine_version" {
  description = "Version of the source engine used to make the backup"
  type        = string
  default     = null
}

variable "db_instance__restore_to_point_in_time_restore_time" {
  description = "The date and time to restore from. Value must be a time in Universal Coordinated Time (UTC) format and must be before the latest restorable time for the DB instance. Cannot be specified with db_instance__restore_to_point_in_time_use_latest_restorable_time."
  type        = string
  validation {
    condition     = (var.db_instance__restore_to_point_in_time_restore_time == null || can(regex("^(\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z)$", var.db_instance__restore_to_point_in_time_restore_time))) && !(var.db_instance__restore_to_point_in_time_restore_time != null && var.db_instance__restore_to_point_in_time_use_latest_restorable_time == true)
    error_message = "The db_instance__restore_to_point_in_time_restore_time must be in UTC format (e.g., '2024-08-11T12:34:56Z') and cannot be specified if db_instance__restore_to_point_in_time_use_latest_restorable_time is true."
  }
  default = null
}

variable "db_instance__restore_to_point_in_time_use_latest_restorable_time" {
  description = "A boolean value that indicates whether the DB instance is restored from the latest backup time. Defaults to false. Cannot be specified with restore_time."
  type        = bool
  default     = false
}

variable "db_instance__restore_to_point_in_time_source_db_instance_identifier" {
  description = "The identifier of the source DB instance from which to restore. Must match the identifier of an existing DB instance. Required if source_db_instance_automated_backups_arn or source_dbi_resource_id is not specified."
  type        = string
  default     = null
}

variable "db_instance__restore_to_point_in_time_source_db_instance_automated_backups_arn" {
  description = "The ARN of the automated backup from which to restore. Required if source_db_instance_identifier or source_dbi_resource_id is not specified."
  type        = string
  default     = null
}

variable "db_instance__restore_to_point_in_time_source_dbi_resource_id" {
  description = "The resource ID of the source DB instance from which to restore. Required if source_db_instance_identifier or source_db_instance_automated_backups_arn is not specified."
  type        = string
  default     = null
}

variable "db_instance_character_set_name" {
  description = "The character set name to use for DB encoding in Oracle and Microsoft SQL instances (collation). This can't be changed. Cannot be set with replicate_source_db, restore_to_point_in_time, s3_import, or snapshot_identifier."
  type        = string
  validation {
    condition = (
      var.db_instance_character_set_name == null || (
        var.db_instance_replicate_source_db == null &&
        var.db_instance__restore_to_point_in_time_restore_time != null &&
        var.db_instance__restore_to_point_in_time_source_db_instance_identifier != null &&
        var.db_instance__restore_to_point_in_time_source_db_instance_automated_backups_arn != null &&
        var.db_instance__restore_to_point_in_time_source_dbi_resource_id != null &&
        var.db_instance__restore_to_point_in_time_use_latest_restorable_time != null &&
        var.db_instance_s3_import_bucket_name == null &&
        var.db_instance_snapshot_identifier == null &&
        var.db_instance_character_set_name != null
      )
    )
    error_message = "The character_set_name cannot be set if replicate_source_db, restore_to_point_in_time, s3_import, or snapshot_identifier is specified."
  }
  default = null
}

variable "db_instance_copy_tags_to_snapshot" {
  description = "Copy all Instance tags to snapshots."
  type        = bool
  default     = false
}

variable "db_instance_custom_iam_instance_profile" {
  description = "The instance profile associated with the underlying Amazon EC2 instance of an RDS Custom DB instance."
  type        = string
  default     = null
}

variable "db_instance_db_name" {
  description = "The name of the database to create when the DB instance is created. If this parameter is not specified, no database is created in the DB instance."
  type        = string
  default     = null
}

variable "db_instance_db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC, or in EC2 Classic, if available."
  type        = string
  default     = null
}

variable "db_instance_dedicated_log_volume" {
  description = "Use a dedicated log volume (DLV) for the DB instance. Requires Provisioned IOPS."
  type        = bool
  default     = null
}

variable "db_instance_delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted."
  type        = bool
  default     = true
}

variable "db_instance_deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain to create the instance in. Conflicts with domain_fqdn, domain_ou, domain_auth_secret_arn and a domain_dns_ips."
  type        = string
  default     = null
}

variable "db_instance_domain_fqdn" {
  description = "The fully qualified domain name (FQDN) of the self managed Active Directory domain."
  type        = string
  default     = null
}

variable "db_instance_domain_dns_ips" {
  description = "The IPv4 DNS IP addresses of your primary and secondary self-managed Active Directory domain controllers. Two IP addresses must be provided. Conflicts with domain and domain_iam_role_name."
  type        = list(string)
  default     = null
  validation {
    condition = (var.db_instance_domain_fqdn == null && (
      can(length(var.db_instance_domain_dns_ips) == 2) &&
      can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", var.db_instance_domain_dns_ips[0])) &&
      can(regex("^(\\d{1,3}\\.){3}\\d{1,3}$", var.db_instance_domain_dns_ips[1]))
    )) || var.db_instance_domain_dns_ips == null
    error_message = "If domain_fqdn is provided, domain_dns_ips must be a list of exactly two valid IPv4 addresses. Additionally, domain_dns_ips cannot be set if domain or domain_iam_role_name is specified."
  }
}

variable "db_instance_domain_auth_secret_arn" {
  description = "The ARN for the Secrets Manager secret with the self managed Active Directory credentials for the user joining the domain."
  type        = string
  default     = null
}

variable "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service. "
  type        = string
  default     = null
}

variable "db_instance_domain_ou" {
  description = "The self-managed Active Directory organizational unit for your DB instance to join. Required if domain_fqdn is provided. Conflicts with domain and domain_iam_role_name."
  type        = string
  validation {
    condition     = (var.db_instance_domain_fqdn != null && var.db_instance_domain_ou != null && var.db_instance_domain == null && var.db_instance_domain_iam_role_name == null) || (var.db_instance_domain_ou == null && var.db_instance_domain_fqdn == null)
    error_message = "If domain_fqdn is provided, domain_ou must also be provided. Additionally, domain_ou cannot be set if domain or domain_iam_role_name is specified."
  }
  default = null
}

variable "db_instance_enabled_cloudwatch_logs_exports" {
  description = "Set of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported."
  type        = list(string)
  default     = null
}

variable "db_instance_engine" {
  description = "The database engine to use. Required unless a snapshot_identifier or replicate_source_db is provided."
  type        = string
  default     = null
  validation {
    condition     = var.db_instance_engine == null || (var.db_instance_engine != null && var.db_instance_snapshot_identifier != null && var.db_instance_replicate_source_db != null)
    error_message = "The engine must be specified unless a snapshot_identifier or replicate_source_db is provided."
  }
}

variable "db_instance_engine_version" {
  description = "The engine version to use."
  type        = string
  default     = null
}

variable "db_instance_engine_lifecycle_support" {
  description = "The life cycle type for this DB instance. This setting applies only to RDS for MySQL and RDS for PostgreSQL. Valid values are open-source-rds-extended-support, open-source-rds-extended-support-disabled. Default value is open-source-rds-extended-support."
  type        = string
  validation {
    condition = (
      var.db_instance_engine_lifecycle_support == "open-source-rds-extended-support" ||
      var.db_instance_engine_lifecycle_support == "open-source-rds-extended-support-disabled"
      ) && (
      var.db_instance_engine == null || can(contains(["mysql", "postgres"], lower(var.db_instance_engine)))
    )
    error_message = "The engine_lifecycle_support is only valid for RDS for MySQL and RDS for PostgreSQL with values 'open-source-rds-extended-support' or 'open-source-rds-extended-support-disabled'."
  }
  default = "open-source-rds-extended-support"
}

variable "db_instance_skip_final_snapshot" {
  description = "Specifies whether the DB instance is encrypted. Note that if you are creating a cross-region read replica this field is ignored and you should instead declare kms_key_id with a valid ARN."
  type        = bool
  default     = false
}

variable "db_instance_final_snapshot_identifier" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier."
  type        = string
  default     = null
}

variable "db_instance_storage_encrypted" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier."
  type        = bool
  default     = false
}

variable "db_instance_storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), gp3 (general purpose SSD that needs iops independently) or io1 (provisioned IOPS SSD). The default is io1 if iops is specified, gp2 if not."
  type        = string
  default     = null
}
