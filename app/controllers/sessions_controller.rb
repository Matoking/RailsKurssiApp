class SessionsController < ApplicationController
    def new

    end

    def create
        # haetaan käyttäjä
        user = User.find_by username: params[:username]

        if user && user.authenticate(params[:password])
            session[:user_id] = user.id if not user.nil?
            redirect_to user, notice: "Welcome back!"
        else
            redirect_to :back, notice: "Username/password mismatch"
        end
    end

    def destroy
        session[:user_id] = nil

        redirect_to :root
    end
end
