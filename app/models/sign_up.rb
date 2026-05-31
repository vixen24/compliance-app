class SignUp
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :account
  attr_accessor :name, :email_address, :password, :password_confirmation

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, complexity: true, confirmation: true
  validate :email_address_must_be_unique
  validates :name, presence: true, length: { maximum: 64 }

  def save
    return false unless valid?

    @account = Account.create_with_owner(
      account: {
        name: name
      },
      owner: {
        email_address: email_address,
        password: password,
        password_confirmation: password_confirmation
      }
    )
  end

  private

  def email_address_must_be_unique
    if User.exists?(email_address: email_address)
      errors.add(:email_address, "is already registered")
    end
  end
end
