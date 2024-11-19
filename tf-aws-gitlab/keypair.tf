### Use when executing on GitLab 
# resource "aws_key_pair" "gitlab-key" {
#   key_name   = "gitlab-key"
#   public_key = var.gitlab-key_pair
# }

resource "aws_key_pair" "gitlab-key" {
  key_name   = "gitlab-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDV9FBnyuIJOaetkEQMFEvkvwCjRFTg813nVmXJQK58tCVW0Hmg86W6Fa3h+nEVPxg0+prGuHCIyRbZGVIBxw/cHasvomR5cox7ktbIMCBFCP5v4a1YBgHFju2jJB/HTR8mgwPAtoqbaBOGWrKSoNpvP4q45m4EjpnMeuccROIX13JSc2Chob591Vnk5hpEw1Kyg/ajrRwB6+RjyVrxI4VUo6mcAdVzfSBUX3TaI0/BqoXfQ9cPxzTkww+bVBqgcfPYmv6of+u98tV1+UnKYkXtS6w6YJCaFU3lLphc65VuoOezryTPcG06x/wE7MCjkreftoa2UkPEYo6ruuoz/MIYZiTtKB7bD8ZLRbiQ+kEgvhO577CfbXdavrmVX1Y5Eapsg4oQEwNgAOZVTk9J73Iza158lutlqNKfNXeRsHgtX+Ehh3CvcMw1KvdE6huHatYGSOlJUz9twVhVP++7KpuKlVrtAebZJs0ilUCKQ81MbfK+MGh3SrZ3s/XwaewqlJM= swilliams@Solomons-MacBook-Pro.local"
}

### Use when executing locally 

# resource "aws_key_pair" "gitlab-key" {
#   key_name   = "gitlab-key"
#   public_key = file("~/.ssh/id_rsa.pub")
# }


