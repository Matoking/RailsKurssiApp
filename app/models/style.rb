class Style < ActiveRecord::Base
    include RatingAverage

    has_many :beers
    has_many :ratings, through: :beers

    def self.top(n)
        Style.all.sort_by{ |s| -(s.average_rating||0) }.take(n)
    end

    def to_s
        "#{name}"
    end
end
