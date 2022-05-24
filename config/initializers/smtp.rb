ActionMailer::Base.smtp_settings = {
  domain:         "em2512.gemkhin.com",
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      "apikey",
  password:       ENV.fetch("SENDGRID_API_KEY", '').presence
}