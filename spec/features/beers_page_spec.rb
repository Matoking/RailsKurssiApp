require 'rails_helper'

include Helpers

describe "Beers path" do
    before :each do
        FactoryGirl.create :user
    end

    it "should allow a valid beer to be added" do
        sign_in(username:"Pekka", password:"Foobar1")

        brewery = Brewery.create name:"Test brewery", year:1990
        style = Style.create name:"Test style"

        visit new_beer_path
        fill_in('beer_name', with:"Test beer")
        select(style.name, from:'beer[style_id]')
        select(brewery.name, from:'beer[brewery_id]')

        expect {
            click_button("Create Beer")
        }.to change{Beer.count}.by(1)
    end

    it "should not allow an invalid beer to be added" do
        sign_in(username:"Pekka", password:"Foobar1")

        brewery = Brewery.create name:"Test brewery", year:1990
        style = Style.create name:"Test style"

        visit new_beer_path
        select(style.name, from:'beer[style_id]')
        select(brewery.name, from:'beer[brewery_id]')

        click_button("Create Beer")

        expect(page).to have_content "Name is too short"
    end
end
