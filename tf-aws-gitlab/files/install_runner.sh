### Configure Sudoer
echo "gitlab-runner ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "gitlab-runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

### Install Gitlab Runner
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
sudo yum install gitlab-runner -y 
sudo gitlab-runner status
sudo gitlab-runner start
sudo gitlab-runner stop
sudo gitlab-runner restart

### Register Runner (Docker)  
sudo gitlab-runner register \
  --non-interactive \
  --description "docker-runner" \
  --url "https://gitlab.emagetech.co" \
  --registration-token "glrt-t1_evwNeLJ_i3i54ZRyEn4G" \
  --executor "docker" \
  --docker-image "docker:latest" \
  --tag-list build,test,deploy \
  --docker-privileged \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
  --docker-volumes /etc/docker/certs.d:/etc/docker/certs.d:ro \
  --docker-pull-policy="if-not-present"

sudo gitlab-runner register \
  --non-interactive \
  --description "centos-runner" \
  --tls_verify false \
  --url "https://gitlab.emagetech.co" \
  --registration-token "glrt-dfyCzybk9UN7XrTR-T1u" \
  --executor "centos" \
  --docker-image "centos:latest" \
  --tag-list build,test,deploy \
  --docker-privileged \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
  --docker-volumes /etc/docker/certs.d:/etc/docker/certs.d:ro \
  --docker-pull-policy="if-not-present"
 gitlab-runner run 

  # --dns_search ["kendopz.com"] 

### I'm assuming you are using docker as the executor for you
###  GitLab runner since you did not specify it in your question. Docker executor does not share the /etc/hosts of 
###  the host machine but you can use extra_hosts parameter inside your config.toml to let the runner container know about the custom hostname:

