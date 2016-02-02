class Membership < ActiveRecord::Base
    belongs_to :user
    belongs_to :beerclub

    validate :can_have_only_one_membership_in_club

    def can_have_only_one_membership_in_club
        if Membership.exists? user: user, beerclub: beerclub
            errors.add(:user_id, "can only have one membership in this club")
        end
    end
end
