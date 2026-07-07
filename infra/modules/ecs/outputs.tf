output "alb_dns_name" {
    description = "DNS of load balancer"
    value       = aws_lb.load_balancer.dns_name
}
