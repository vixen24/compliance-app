class SignUp
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attr_accessor :email_address, :password, :password_confirmation
  attr_reader :account, :user

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true
  validate :email_address_must_be_unique

  def create_account
    return false unless valid?

    @account = Account.create_with_owner(
      account: {
        name: generate_account_name
      },
      owner: {
        email_address: email_address,
        password: password,
        password_confirmation: password_confirmation
      }
    )

    @user = @account.users.find_by!(role: :owner)
  end

  private

  def email_address_must_be_unique
    if User.exists?(email_address: email_address)
      errors.add(:email_address, "is already registered")
    end
  end

  def generate_account_name
    SecureRandom.uuid.gsub("-", "").first(12)
    # SecureRandom.uuid.gsub("-", "").first(12).to_i(36)
    # AccountNameGenerator.new(name: full_name).generate
  end
end
