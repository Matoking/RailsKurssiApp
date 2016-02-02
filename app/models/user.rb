class User < ActiveRecord::Base
    include RatingAverage

    has_secure_password

    validates :username, uniqueness: true,
                         length: { minimum: 3,
                                   maximum: 15 }

    validates :password, length: { minimum: 4 }

    validate :password_strength_check

    has_many :ratings, dependent: :destroy
    has_many :memberships, dependent: :destroy

    def password_strength_check
        if password.scan(/[A-Z]/).length == 0 || password.scan(/[0-9]/).length == 0
            errors.add(:password, "needs to have at least one uppercase letter and one number")
        end
    end

    def to_s
        "#{username}"
    end
end
