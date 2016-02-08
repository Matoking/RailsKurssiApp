require 'rails_helper'

RSpec.describe Beer, type: :model do
    it "is saved" do
        beer = Beer.create name:"Test Beer", style:"Test Style"

        expect(beer.valid?).to be(true)
        expect(Beer.count).to eq(1)
    end

    it "is not saved without a name" do
        beer = Beer.create style:"Test Style"

        expect(beer.valid?).to be(false)
        expect(Beer.count).to eq(0)
    end

    it "is not saved without a style" do
        beer = Beer.create name:"Test Beer"

        expect(beer.valid?).to be(false)
        expect(Beer.count).to eq(0)
    end
end
