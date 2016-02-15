class PlacesController < ApplicationController
    def index
    end

    def show
        @place = BeermappingApi.place(params[:id])
        @place.blogmap = @place.blogmap[@place.blogmap.index("//")..-1]
    end

    def search
        @places = BeermappingApi.places_in(params[:city])
        if @places.empty?
            redirect_to places_path, notice: "No locations in #{params[:city]}"
        else
            render :index
        end
    end
end
