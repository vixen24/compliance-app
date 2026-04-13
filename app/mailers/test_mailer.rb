class TestMailer < ApplicationMailer
  default from: "sender@williamidakwo.com"  # must be a verified sender in SES

  def test_email(to_email)
    mail(
      to: to_email,
      subject: "SMTP Test Email",
      body: "This is a test email sent via your configured SMTP settings."
    )
  end
end
