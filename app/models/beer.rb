class Beer < ActiveRecord::Base
    belongs_to :brewery
    has_many :ratings

    def average_rating
        if ratings.empty?
            return nil
        else
            sum = 0
            ratings.each { |rating| sum += rating.score }
            return sum.to_f / ratings.count.to_f
        end
    end
end
