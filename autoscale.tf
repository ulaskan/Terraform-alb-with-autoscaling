resource "aws_autoscaling_group" "infra_autoscaling" {
  name = "infra_autoscaling"
  launch_configuration = "${aws_launch_configuration.infra_launchconfig.name}"
  depends_on = ["aws_launch_configuration.infra_launchconfig"]
  name = "${var.environment}-${var.project}-${var.repository}-asg"
  vpc_zone_identifier  = ["${aws_subnet.infra_private_subnet1.id}", "${aws_subnet.infra_private_subnet2.id}"]
  target_group_arns = ["${aws_alb_target_group.alb_target.arn}"]
  placement_group = "${aws_placement_group.alb_placement.id}"
  min_size = 1
  max_size = 3
  desired_capacity = 1
  health_check_grace_period = 10
  health_check_type = "EC2"
  force_delete = true
  tag {
      key = "Name"
      value = "${var.environment}_${var.project}_${var.repository}_web"
      propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.infra_autoscaling.id}"
  alb_target_group_arn   = "${aws_alb_target_group.alb_target.arn}"
}

resource "aws_autoscaling_policy" "asg_up_policy" {
  name = "${var.environment}-${var.project}-${var.repository}-asg-up-policy"
  autoscaling_group_name = "${aws_autoscaling_group.infra_autoscaling.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name = "${var.environment}-${var.project}-${var.repository}-up-alarm"
  alarm_description = "${var.environment}-${var.project}-${var.repository}-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "70"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.infra_autoscaling.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.asg_up_policy.arn}"]
}

resource "aws_autoscaling_policy" "asg_down_policy" {
  name = "${var.environment}-${var.project}-${var.repository}-asg-down-policy"
  autoscaling_group_name = "${aws_autoscaling_group.infra_autoscaling.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "-1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name = "${var.environment}-${var.project}-${var.repository}-down-alarm"
  alarm_description = "${var.environment}-${var.project}-${var.repository}-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "30"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.infra_autoscaling.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.asg_down_policy.arn}"]
}
