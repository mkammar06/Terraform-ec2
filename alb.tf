resource "aws_security_group" "albsg-manju" {
  name = "albsg-manju"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_alb" "weblb-manju" {
  name            = "weblb-manju"
  internal        = false
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.albsg-manju.id]
}


resource "aws_lb_target_group" "myalb-manju-tg" {
  name     = "myalb-manju-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_target_group_attachment" "ia" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.myalb-manju-tg.arn
  target_id        = aws_instance.webserver[count.index].id

}

resource "aws_lb_listener" "weblisterner" {
  load_balancer_arn = aws_alb.weblb-manju.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myalb-manju-tg.arn
  }
}

output "albdns" {
  value = aws_alb.weblb-manju.dns_name
}