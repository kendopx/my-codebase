gitlab_kas['enable'] = true
gitlab_rails['initial_root_password'] = 'Redhat123###!'
external_url 'https://gitlab.emagetech.co'
registry_external_url 'https://gitlab.emagetech.co'
letsencrypt['enable'] = true
letsencrypt['contact_emails'] = ['solomon.fwilliams@gmail.com']
letsencrypt['auto_renew'] = true
letsencrypt['auto_renew_hour'] = 12
letsencrypt['auto_renew_minute'] = 30
letsencrypt['auto_renew_day_of_month'] = "*/7"

nginx['enable'] = true
nginx['client_max_body_size'] = '250m'
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.emagetech.co.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.emagetech.co.key"
nginx['ssl_protocols'] = "TLSv1.1 TLSv1.2 TLSv1.3"
nginx['custom_gitlab_server_config'] = "location /api/v4/jobs/request {\n deny all;\n return 503;\n}\n"

gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = {
  'main' => {
    'label' => 'Active Directory',
    'host' =>  'txaddc01.emagetech.co',
    'port' => 389,
    'uid' => 'sAMAccountName',
    'encryption' => 'plain',
    'base' => 'dc=emagetech,dc=co',
    'bind_dn' => 'cn=VMADMIN,cn=Users,dc=emagetech,dc=co',
    'password' => 'Password1'
  }
}

gitlab_rails['omniauth_providers'] = [
  {
    name: "github",
    label: "GitHub", # optional label for login button, defaults to "GitHub"
    app_id: "Ov23lioG4edNXuzWQIzZ",
    app_secret: "9aa41412d7535393e7729b0f562fb4f7b68a28c7",
    url: "https://github.com/",
    verify_ssl: false,
    args: { scope: "user:email" }
  }
]

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "zlmhkveg375@gmail.com"
gitlab_rails['smtp_password'] = "Hd!diVdhjdvk"
gitlab_rails['smtp_domain'] = "smtp.gmail.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false
...
gitlab_rails['smtp_openssl_verify_mode'] = 'peer'

gitlab_rails['gitlab_email_from'] = 'gitlab@gitlab.emagetech.co'
gitlab_rails['gitlab_email_reply_to'] = 'noreply@gitlab.emagetech.co'
environment = ["GIT_SSL_NO_VERIFY=true"]