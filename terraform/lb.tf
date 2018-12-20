

resource "aws_security_group" "lb" {
  name        = "personal-dev-lb"
  description = "Allow traffic to external elb"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress {
    # Allow http
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow https
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0

    # Egress on all procals and ports?
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  name = "personal-dev"

  internal           = false
  load_balancer_type = "application"

  enable_deletion_protection = true
  subnets                    = ["${data.aws_subnet_ids.subnet_ids.ids}"]
  security_groups            = ["${aws_security_group.lb.id}"]
}

resource "aws_lb_target_group" "lb" {
  name = "personal-dev-tls-termination"

  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.vpc.id}"

  # This is the fabio health check endpoiont
  health_check {
    path    = "/health"
    port    = 80
    matcher = "200"
  }
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.cert.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lb.arn}"
  }
}

resource "aws_route53_record" "m_rivet_app" {
  zone_id = "${aws_route53_zone.rivet_app.zone_id}"
  name    = "m.rivet.app"
  type    = "A"

  alias {
    name                   = "${aws_lb.lb.dns_name}"
    zone_id                = "${aws_lb.lb.zone_id}"
    evaluate_target_health = true
  }
}
