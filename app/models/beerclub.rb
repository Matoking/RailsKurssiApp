class Beerclub < ActiveRecord::Base
    has_many :memberships

    has_many :members, through: :memberships, source: :user

    validate :can_have_only_one_membership_in_club

    def to_s
        "#{name}"
    end
end
