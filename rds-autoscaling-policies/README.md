# RDS Autoscaling policies

## Using this module

### Important notice

**Make sure your cluster definition sets up at least one read replica!**

Add the module into your Terraform configuration:

```hcl
# Assume there is an RDS cluster being defined somewhere like this:
resource "aws_rds_cluster" "users_database" {
  # ...
}

resource "aws_rds_cluster_instance" "cluster_master_instance" {
  # ...
}

resource "aws_rds_cluster_instance" "cluster_read_replicas" {
  # ...
}

# And later on you load the module:
module "rds_autoscaling_policies" {
  source = "github.com/ThoughtWorks-DPS/tf-modules//rds-autoscaling-policies"
  rds_cluster_id = "cluster:${aws_rds_cluster.users_database.id}"
  min_replica_count = 2
}
```

## Configuring the policies

Your setup HAS to provide a value for `rds_cluster_id`. It can something like this: `"cluster:${aws_rds_cluster.users_database.id}"`

Other variables have default values:

 - `min_replica_count`: defaults to `1` (minimum required for the policy to be useful)
 - `max_replica_count`: defaults to `15` (AWS' maximum value)
 - `cpu_utilization_target`: defaults to `50`
 - `cpu_utilization_scale_in_cooldown`: defaults to `300` (AWS' default value)
 - `cpu_utilization_scale_out_cooldown`: defaults to `300` (AWS' default value)
 - `connections_count_target`: defaults to `100`
 - `connections_count_scale_in_cooldown`: defaults to `300` (AWS' default value)
 - `connections_count_scale_out_cooldown`: defaults to `300` (AWS' default value)
