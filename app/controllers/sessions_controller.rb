class SessionsController < ApplicationController
    include SessionsHelper
    include ApplicationHelper
    
    def new
        if isLoggedIn?
            redirect_to clients_path
        end
        # render 'new'
    end
    
    def create
        print params
        if params[:session] == nil
            user = User.from_omniauth(request.env["omniauth.auth"])
            session[:user_id] = user.id
            redirect_to clients_path
        else

        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.password == (params[:session][:password])
            flash[:danger] = ''
            log_in user
            redirect_to clients_path
            # Log the user in and redirect to the user's show page.
        else
            # Create an error message.
            flash[:danger] = 'Invalid email/password combination' # Not quite right!
            render 'new'
        end
        end
    end
    
    def destroy
        log_out
        redirect_to login_path
    end

end
