class MagicLinkMailer < ApplicationMailer
  def sign_up_instructions(magic_link)
    @magic_link = magic_link
    @user = @magic_link.user

    mail to: @user.email_address, subject: "Your OTP is #{ @magic_link.code }"
  end
end
