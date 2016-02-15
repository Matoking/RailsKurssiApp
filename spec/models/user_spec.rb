require 'rails_helper'
RSpec.describe User, type: :model do
    def create_beer_with_rating(user, score)
        beer = FactoryGirl.create(:beer)
        FactoryGirl.create(:rating, score:score, beer:beer, user:user)
        return beer
    end

    def create_beers_with_ratings(user, *scores)
        scores.each do |score|
            create_beer_with_rating(user, scored)
        end
    end

    it "has the username set correctly" do
        user = User.new username:"Pekka"

        expect(user.username).to eq("Pekka")
    end

    it "is not saved without a password" do
        user = User.create username:"Pekka"

        expect(user.valid?).to be(false)
        expect(User.count).to eq(0)
    end

    it "is not saved with a short password" do
        user = User.create username:"Pekka", password:"aab", password_confirmation:"aab"

        expect(user.valid?).to be(false)
        expect(User.count).to eq(0)
    end

    it "is not saved with a letter-only password" do
        user = User.create username:"Pekka", password:"password", password_confirmation:"password"

        expect(user.valid?).to be(false)
        expect(User.count).to eq(0)
    end

    describe "with a proper password" do
        let(:user){ FactoryGirl.create(:user) }

        it "is saved" do
            expect(user).to be_valid
            expect(User.count).to eq(1)
        end

        it "and with two ratings, has the correct average rating" do
            user.ratings << FactoryGirl.create(:rating)
            user.ratings << FactoryGirl.create(:rating2)

            expect(user.ratings.count).to eq(2)
            expect(user.average_rating).to eq(15.0)
        end
    end

    describe "favorite beer" do
        let(:user){ FactoryGirl.create(:user) }

        it "has method for determining the favorite_beer" do
            expect(user).to respond_to(:favorite_beer)
        end

        it "without ratings does not have a favorite beer" do
            expect(user.favorite_beer).to eq(nil)
        end

        it "is the only rated if only one rating" do
            beer = FactoryGirl.create(:beer)
            rating = FactoryGirl.create(:rating, beer:beer, user:user)

            expect(user.favorite_beer).to eq(beer)
        end

        it "is the one with highest rating if several rated" do
            create_beer_with_rating(user, 10)
            best = create_beer_with_rating(user, 25)
            create_beer_with_rating(user, 7)

            expect(user.favorite_beer).to eq(best)
        end
    end

    describe "favorite style" do
        let(:user){ FactoryGirl.create(:user) }

        it "is the one with highest rating average" do
            style = FactoryGirl.create(:style, style: "Best Style")
            style2 = FactoryGirl.create(:style, style: "Worst Style")

            beer = FactoryGirl.create(:beer, style: style)
            beer2 = FactoryGirl.create(:beer, style: style)
            beer3 = FactoryGirl.create(:beer, style: style2)
            beer4 = FactoryGirl.create(:beer, style: style2)

            rating = FactoryGirl.create(:rating, beer:beer, user:user, score:25)
            rating2 = FactoryGirl.create(:rating, beer:beer2, user:user, score:20)
            rating3 = FactoryGirl.create(:rating, beer:beer3, user:user, score:15)
            rating4 = FactoryGirl.create(:rating, beer:beer4, user:user, score:10)

            expect(user.favorite_style).to eq("Best Style")
        end
    end

    describe "favorite brewery" do
        let(:user){ FactoryGirl.create(:user) }

        it "is the one with highest rating average" do
            brewery = FactoryGirl.create(:brewery, name: "Best Brewery")
            brewery2 = FactoryGirl.create(:brewery, name: "Worst Brewery")

            beer = FactoryGirl.create(:beer, brewery:brewery)
            beer2 = FactoryGirl.create(:beer, brewery:brewery)
            beer3 = FactoryGirl.create(:beer, brewery:brewery2)
            beer4 = FactoryGirl.create(:beer, brewery:brewery2)

            rating = FactoryGirl.create(:rating, beer:beer, user:user, score:25)
            rating2 = FactoryGirl.create(:rating, beer:beer2, user:user, score:20)
            rating3 = FactoryGirl.create(:rating, beer:beer3, user:user, score:15)
            rating4 = FactoryGirl.create(:rating, beer:beer4, user:user, score:10)

            expect(user.favorite_brewery).to eq(brewery)
        end
    end
end
