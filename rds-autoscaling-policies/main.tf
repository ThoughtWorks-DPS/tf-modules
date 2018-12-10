resource "aws_appautoscaling_target" "replicas" {
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "${var.rds_cluster_id}"
  min_capacity       = "${var.min_replica_count}"
  max_capacity       = "${var.max_replica_count}"
}

resource "aws_appautoscaling_policy" "cpu_bound" {
  name               = "cpu-auto-scaling"
  service_namespace  = "${aws_appautoscaling_target.replicas.service_namespace}"
  scalable_dimension = "${aws_appautoscaling_target.replicas.scalable_dimension}"
  resource_id        = "${aws_appautoscaling_target.replicas.resource_id}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }

    target_value = "${var.cpu_utilization_target}"
    scale_in_cooldown = "${var.cpu_utilization_scale_in_cooldown}"
    scale_out_cooldown = "${var.cpu_utilization_scale_out_cooldown}"
  }
}

resource "aws_appautoscaling_policy" "connections_bound" {
  depends_on         = ["aws_appautoscaling_policy.cpu_bound"]
  name               = "connections-auto-scaling"
  service_namespace  = "${aws_appautoscaling_target.replicas.service_namespace}"
  scalable_dimension = "${aws_appautoscaling_target.replicas.scalable_dimension}"
  resource_id        = "${aws_appautoscaling_target.replicas.resource_id}"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageDatabaseConnections"
    }

    target_value = "${var.connections_count_target}"
    scale_in_cooldown = "${var.connections_count_scale_in_cooldown}"
    scale_out_cooldown = "${var.connections_count_scale_out_cooldown}"
  }
}

