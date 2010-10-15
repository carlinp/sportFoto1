# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale

  layout "general"
  helper :all # include all helpers, all the time
  helper_method :admin_logged_in?, :approved_photographer_logged_in?
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  $app_config = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def set_locale
    if params[:locale] != nil
      I18n.locale = params[:locale]
    else
      I18n.locale = extract_locale_from_tld
    end
  end
  ## Get locale from top-level domain or return nil if such locale is not available
  ## You have to put something like: # 127.0.0.1 application.com
  ## 127.0.0.1 application.it # 127.0.0.1 application.pl
  ## in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').first
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : nil
  end

  private
  def require_admin
    unless admin_logged_in?
      flash[:error] = "Ennek a funkciónak a használatához adminisztrátori jogosultsággal kell rendelkezned!"
      redirect_to :not_authenticated
    end
  end

  def admin_logged_in?
    return session[:user_id] == 1
  end

  def approved_photographer_logged_in?
    user = User.find session[:user_id]
    if (user != nil and user.photographer != nil)
      return user.photographer.is_approved
    end

    return false
  end
  
end

