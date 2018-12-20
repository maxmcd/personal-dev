

resource "aws_instance" "default" {
  ami           = "ami-04d4a23107c047ed3"
  instance_type = "t2.medium"
  subnet_id = "subnet-9a35ebb1"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

}

resource "aws_lb_target_group_attachment" "default" {
  target_group_arn = "${aws_lb_target_group.lb.arn}"
  target_id        = "${aws_instance.default.id}"
  port             = 80
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.default.id}"
  vpc      = true
}


resource "aws_route53_record" "ssh" {
  zone_id = "${aws_route53_zone.rivet_app.id}"
  name    = "ssh.rivet.app"
  type    = "A"
  ttl     = 60
  records = ["${aws_eip.lb.public_ip}"]
}


resource "aws_security_group" "instance" {
  name   = "personal-dev"
  vpc_id = "${data.aws_vpc.vpc.id}"

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
