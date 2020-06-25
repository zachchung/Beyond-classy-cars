class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # FB 3rd-party login:
  def facebook
    user = User.find_for_facebook_oauth(request.env['omniauth.auth'])

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url # if user refuse to sign-in with FB, go to regular sign-up page
    end
  end
end
