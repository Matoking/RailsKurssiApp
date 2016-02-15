require 'rails_helper'

include Helpers

describe "User" do
    let!(:user) { FactoryGirl.create :user }

    describe "who has signed up" do
        it "can signin with right credentials" do
            sign_in(username:"Pekka", password:"Foobar1")

            expect(page).to have_content 'Welcome back!'
            expect(page).to have_content 'Pekka'
        end

        it "is redirected back to signin form if wrong credentials given" do
            sign_in(username:"Pekka", password:"wrong")

            expect(current_path).to eq(signin_path)
            expect(page).to have_content 'Username/password mismatch'
        end

        it "can view his favorite style" do
            style1 = FactoryGirl.create(:style, name:"Best Style")
            style2 = FactoryGirl.create(:style, name:"Worst Style")

            beer1 = FactoryGirl.create(:beer, name:"Best Beer", style: style1)
            beer2 = FactoryGirl.create(:beer, name:"Worst Beer", style: style2)

            FactoryGirl.create(:rating, beer:beer1, user: user, score: 20)
            FactoryGirl.create(:rating, beer:beer1, user: user, score: 10)

            visit user_path(user)

            expect(page).to have_content "Favorite style: Best Style"
        end

        it "can view his favorite brewery" do
            style1 = FactoryGirl.create(:style, name:"Best Style")
            style2 = FactoryGirl.create(:style, name:"Worst Style")

            brewery1 = FactoryGirl.create(:brewery, name:"Best Brewery", year:1999)
            brewery2 = FactoryGirl.create(:brewery, name:"Worst Brewery", year:1990)

            beer1 = FactoryGirl.create(:beer, name:"Best Beer", style: style1, brewery: brewery1)
            beer2 = FactoryGirl.create(:beer, name:"Worst Beer", style: style2, brewery: brewery2)

            FactoryGirl.create(:rating, beer:beer1, user: user, score: 20)
            FactoryGirl.create(:rating, beer:beer1, user: user, score: 10)

            visit user_path(user)

            expect(page).to have_content "Favorite brewery: Best Brewery"
        end
    end

    it "when signed up with good credentials, is added to the system" do
        visit signup_path
        fill_in('user_username', with:'Brian')
        fill_in('user_password', with:'Secret55')
        fill_in('user_password_confirmation', with:'Secret55')

        expect{
            click_button('Create User')
        }.to change{User.count}.by(1)
    end
end
