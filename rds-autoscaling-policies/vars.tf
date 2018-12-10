variable "rds_cluster_id" {}

variable "min_replica_count" { default = 1 }
variable "max_replica_count" { default = 15 }

variable "cpu_utilization_target" { default = 50 }
variable "cpu_utilization_scale_in_cooldown" { default = 300 }
variable "cpu_utilization_scale_out_cooldown" { default = 300 }

variable "connections_count_target" { default = 100 }
variable "connections_count_scale_in_cooldown" { default = 300 }
variable "connections_count_scale_out_cooldown" { default = 300 }
