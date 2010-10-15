# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def print_logged_in_user_email
    @user = User.find(session[:user_id])
    return @user.email if @user
  end

  def require_user
    if session[:user_id] > 0
      return true
    end
  
    return false
  end

  def require_admin
    return false
  end

  def require_self
    if session[:user_id] == params[:id]
      return true
    end
  
    return false
  end

  def require_exact_user(user_id)
    if session[:user_id] == user_id
      return true
    end
  
    return false
  end

  def dt(key, options = {})
    I18n.translate_default(key, options)
  end

end
