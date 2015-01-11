class SessionsController < ApplicationController
  def create
    session[:current_user] = request.env['omniauth.auth']
    User.create_or_update_user_from_omniauth(request.env['omniauth.auth'])
    redirect_to session[:after_auth_url] || '/'
  end
  
  def new_google_auth
    session[:after_auth_url] = params[:next]
    session[:current_user] = nil
    redirect_to '/auth/google_oauth2'
  end
end
