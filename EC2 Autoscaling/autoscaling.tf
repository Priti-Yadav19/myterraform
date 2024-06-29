# Autoscaling launch configuration
resource "aws_launch_configuration" "as_lc" {
  name_prefix   = "as_lc"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name = aws_key_pair.levelup_key.key_name
}

# Auto scaling group
resource "aws_autoscaling_group" "ASG" {
  name                      = "ASG"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 200
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.as_lc.name
  vpc_zone_identifier       = ["us-east-2a", "us-east-2b"]
}

# Autoscaling configuration policy- scaling alarm
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ASG.name
  policy_type = "simpleScaling"
}

# Autoscaling cloud watch monitoring
resource "aws_cloudwatch_metric_alarm" "CWalarm" {
  alarm_name                = "CWalarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = aws_autoscaling_group.ASG.name
  actions_enabled = true
  alarm_actions = aws_autoscaling_policy.cpu_policy.name
}

# Auto descaling policy
resource "aws_autoscaling_policy" "scaledown_policy" {
  name                   = "scaledown_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ASG.name
  policy_type = "simpleScaling"
}

# Auto descaling cloudwatch
resource "aws_cloudwatch_metric_alarm" "CWalarmscaledown" {
  alarm_name                = "CWalarmscaledown"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = aws_autoscaling_group.ASG.name
  actions_enabled = true
  alarm_actions = aws_autoscaling_policy.scaledown_policy.name
}
