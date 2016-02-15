class BeermappingApi
    def self.place(id)
        Rails.cache.fetch("place:" + id.to_s, expires_in: 604800.seconds) { fetch_place(id) }
    end

    def self.places_in(city)
        city = city.downcase
        # Expiration time for cache: 7 days
        Rails.cache.fetch("city:" + city, expires_in: 604800.seconds) { fetch_places_in(city) }
    end

    private

    def self.fetch_place(id)
        url = "http://beermapping.com/webservice/locquery/#{key}/"

        response = HTTParty.get "#{url}#{id}"
        place = response.parsed_response["bmp_locations"]["location"]

        return nil if place.is_a?(Hash) and place['status'].nil?
        Place.new(place)
    end

    def self.fetch_places_in(city)
        #url = "http://beermapping.com/webservice/loccity/#{key}/"
        url = 'http://stark-oasis-9187.herokuapp.com/api/'

        response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
        places = response.parsed_response["bmp_locations"]["location"]

        return [] if places.is_a?(Hash) and places['id'].nil?

        places = [places] if places.is_a?(Hash)
        places.map do | place |
            Place.new(place)
        end
    end

    def self.key
        raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
        ENV['APIKEY']
    end
end
