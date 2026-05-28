class TestMailer < ApplicationMailer
  # default from: "sender@williamidakwo.com"  # Verified sender in SES
  default from: "get-otp@cybersecomply.com"

  def hello
    mail(
      subject: "Hello from Postmark",
      to: "widakwo@deloitte.com",
      html_body: "<strong>Hello</strong> dear Postmark user.",
      track_opens: "true",
      message_stream: "outbound")
  end
end
