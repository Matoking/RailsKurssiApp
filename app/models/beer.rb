class Beer < ActiveRecord::Base
    include RatingAverage

    belongs_to :brewery
    has_many :ratings, dependent: :destroy
    has_many :breweries, through: :ratings
    has_many :raters, -> { uniq }, through: :ratings, source: :user

    validates :name, length: { minimum: 1 }
    validates :style, length: { minimum: 1 }

    def average
        return 0 if ratings.empty?
        ratings.map{ |r| r.score}.sum / ratings.count.to_f
    end

    def to_s
        "#{name} (#{brewery.name})"
    end
end
