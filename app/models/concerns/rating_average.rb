module RatingAverage
    extend ActiveSupport::Concern

    def average_rating
        if ratings.empty?
            nil
        else
            ratings.inject(0) { |sum, rating| sum + (rating.score) }.to_f / ratings.count.to_f
        end
    end
end
