resource "aws_lb" "load_balancer" {
    name = "${var.env}-alb"
    load_balancer_type = "application"
    security_groups = [var.alb_sg_id]
    subnets = var.public_subnet_ids
    tags = {
        Name = "${var.env}-alb"
    }
}

resource "aws_lb_target_group" "target_group" {
    name = "${var.env}-tg"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = var.vpc_id
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.target_group.arn
    }
}

resource "aws_iam_role" "ecs_role" {
    name = "${var.env}-ecs-role"
    assume_role_policy = jsonencode(
        {
            Version = "2012-10-17"
            Statement = [
                {
                    Action = "sts:AssumeRole"
                    Effect = "Allow"
                    Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
            }
        ]})
}

resource "aws_iam_role_policy_attachment" "ecs_role_policy" {
    role = aws_iam_role.ecs_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "cluster" {
    name = "${var.env}-cluster"
}

resource "aws_ecs_task_definition" "app_task" {
    family = "${var.env}-app-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_role.arn
    container_definitions = jsonencode([{
            name      = "app"
            image     = "nginx:latest"
            essential = true
            portMappings = [
                {
                    containerPort = 80
                    hostPort      = 80
                }
            ]}])
}

resource "aws_ecs_service" "app_service" {
    name = "${var.env}-app-service"
    cluster = aws_ecs_cluster.cluster.id
    task_definition = aws_ecs_task_definition.app_task.arn
    launch_type     = "FARGATE"
    desired_count   = 2
    network_configuration {
        subnets          = var.private_subnet_ids
        security_groups  = [var.ecs_sg_id]
        assign_public_ip = false
    }
    load_balancer {
        target_group_arn = aws_lb_target_group.target_group.arn
        container_name   = "app"
        container_port   = 80
    }
}
