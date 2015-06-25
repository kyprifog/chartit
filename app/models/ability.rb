class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :read, :create, :update, :destroy, :new, to: :crud
    can [:crud], Chart do |chart|
      chart.user == user
    end
  end
end
