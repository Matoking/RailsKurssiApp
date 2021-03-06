class User < ActiveRecord::Base
    include RatingAverage

    has_secure_password

    validates :username, uniqueness: true,
                         length: { minimum: 3,
                                   maximum: 15 }

    validates :password, length: { minimum: 4 }

    validate :password_strength_check

    has_many :ratings, dependent: :destroy
    has_many :beers, through: :ratings
    has_many :memberships, dependent: :destroy

    def password_strength_check
        if password == nil || password.scan(/[A-Z]/).length == 0 || password.scan(/[0-9]/).length == 0
            errors.add(:password, "needs to have at least one uppercase letter and one number")
        end
    end

    def self.top_raters(n)
        User.all.sort_by{ |u| -(u.ratings.count||0) }.take(n)
    end

    def favorite_beer
        return nil if ratings.empty?

        ratings.order(score: :desc).limit(1).first.beer
    end

    def favorite_style
        favorite :style
      end

    def favorite_brewery
        favorite :brewery
    end

    def favorite(category)
        return nil if ratings.empty?

        rated = ratings.map{ |r| r.beer.send(category) }.uniq
        rated.sort_by { |item| -rating_of(category, item) }.first
    end

    def rating_of(category, item)
        ratings_of = ratings.select{ |r| r.beer.send(category)==item }
        ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
    end

    def to_s
        "#{username}"
    end
end
