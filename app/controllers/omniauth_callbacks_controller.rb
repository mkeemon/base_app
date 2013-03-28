class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
	  generic_provider
	end
	
	def linkedin
	  generic_provider
  end
  
  def generic_provider
    #puts request.env["omniauth.auth"]
    @user = User.find_for_generic_provider(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      @user.ensure_authentication_token!
      @user.remember_me!
	    redirect_to "/callback/#{remember_token(@user)}" 
    else
      redirect_to "/err_500"
    end
  end
	
	def remember_token(resource)
    data = resource_class.serialize_into_cookie(resource)
    "#{data.first.first}-#{data.last}"
  end
end