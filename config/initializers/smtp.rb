ActionMailer::Base.smtp_settings = {
  domain:         "em2883.app.markiee.co",
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      "apikey",
  password:       ENV.fetch("SENDGRID_API_KEY", "").presence
}

# Ports
# 25, 587 (for unencrypted/TLS connections)
# 465 (for SSL connections)
