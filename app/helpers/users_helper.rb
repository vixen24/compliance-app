module UsersHelper
  def assignable_role_options
    User.assignable_roles.keys.map { |r| [ r.humanize, r ] }
  end

  def active_options
    [ [ "Active", true ], [ "Inactive", false ] ]
  end
end
