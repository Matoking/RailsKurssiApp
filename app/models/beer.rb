class Beer < ActiveRecord::Base
    belongs_to :brewery
    has_many :ratings

    def average_rating
        if ratings.empty?
            nil
        else
            ratings.inject(0) { |sum, rating| sum + (rating.score) }.to_f / ratings.count.to_f
        end
    end

    def to_s
        "#{name} (#{brewery.name})"
    end
end
