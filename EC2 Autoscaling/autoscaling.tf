# Fetching subnet IDs dynamically
data "aws_subnet" "subnet1" {
  id = "subnet-0eff5706bcb6e07fd"
}

data "aws_subnet" "subnet2" {
  id = "subnet-0b003de7c5a5726ba"
}

# Auto scaling group
resource "aws_autoscaling_group" "myASG" {
  name                      = "myASG"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 200
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.as_lc.name
  vpc_zone_identifier       = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]

  tag {
    key                 = "Name"
    value               = "autoscaling-instance"
    propagate_at_launch = true
  }
}

# Launch configuration
resource "aws_launch_configuration" "as_lc" {
  name_prefix   = "as_lc"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
}

# Generate key
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Autoscaling policy - scaling up
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.myASG.name
  policy_type            = "SimpleScaling"
}

# CloudWatch alarm for scaling up
resource "aws_cloudwatch_metric_alarm" "CWalarm" {
  alarm_name                = "CWalarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "This metric monitors EC2 CPU utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.myASG.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_policy.arn]
}

# Autoscaling policy - scaling down
resource "aws_autoscaling_policy" "scaledown_policy" {
  name                   = "scaledown_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.myASG.name
  policy_type            = "SimpleScaling"
}

# CloudWatch alarm for scaling down
resource "aws_cloudwatch_metric_alarm" "CWalarmscaledown" {
  alarm_name                = "CWalarmscaledown"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "This metric monitors EC2 CPU utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.myASG.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scaledown_policy.arn]
}
