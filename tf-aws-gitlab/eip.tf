resource "aws_eip" "gitlab_eip" {
  instance = aws_instance.gitlab.id

  tags = {
    Name = "gitlab_eip"
  }
}