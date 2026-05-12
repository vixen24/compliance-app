class AccountPresentConstraint
  def matches?(request)
    Current.account.present?
  end
end
