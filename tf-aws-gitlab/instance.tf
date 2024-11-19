# launch the ec2 instance and install website
resource "aws_instance" "gitlab" {
  #ami                    = data.aws_ami.amzlinux2.id
  ami                    = "ami-0c6d2bc35c65a2a45"
  instance_type          = var.instance_type
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.gitlab_sg.id]
  key_name               = aws_key_pair.gitlab-key.key_name
  # user_data              = file("files/install_gitlab.sh")


  # root disk
  root_block_device {
    volume_size           = "30"
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "gitlab.emagetech.co"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y git curl policycoreutils openssh-server postfix
    sudo systemctl enable postfix
    sudo systemctl start postfix

    # Add GitLab repository and install GitLab
    curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
    sudo EXTERNAL_URL="https://${var.gitlab_domain}" yum install -y gitlab-ee

    # Start GitLab
    sudo gitlab-ctl reconfigure

    # Configure Sudoer
    echo "gitlab-runner ALL=(ALL:ALL) ALL" >> /etc/sudoers
    echo "gitlab-runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

    # Install Gitlab Runner
    curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
    sudo yum install gitlab-runner -y 
    sudo gitlab-runner status
    sudo gitlab-runner start
    sudo gitlab-runner stop
    sudo gitlab-runner restart
  EOF
}




