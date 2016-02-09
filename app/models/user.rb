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

    def favorite_beer
        return nil if ratings.empty?

        ratings.order(score: :desc).limit(1).first.beer
    end

    def favorite_style
        return nil if ratings.empty?

        styles = Beer.select(:style).map(&:style).uniq

        highest_average = 0.0
        highest_average_style = nil
        styles.each do |name|
            style_average = ratings.joins(:beer).where("beers.style = ?", name).average(:score)
            if style_average == nil
                style_average = 0.0
            end

            if style_average > highest_average
                highest_average = style_average
                highest_average_style = name
            end
        end

        return highest_average_style
    end

    def favorite_brewery
        return nil if ratings.empty?

        breweries = Brewery.all

        highest_average = 0
        highest_average_brewery = nil
        breweries.each do |brewery|
            style_average = ratings.joins(:beer).joins("INNER JOIN breweries ON breweries.id = beers.brewery_id").average(:score)
            if style_average == nil
                style_average = 0.0
            end

            if style_average > highest_average
                highest_average = style_average
                highest_average_brewery = brewery
            end
        end

        return highest_average_brewery
    end

    def to_s
        "#{username}"
    end
end
