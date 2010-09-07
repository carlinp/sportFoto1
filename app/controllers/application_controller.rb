# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "general"
  helper :all # include all helpers, all the time
  helper_method :admin_logged_in?, :approved_photographer_logged_in?
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  $app_config = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

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

  def to_slug
    #strip the string
    ret = self.strip

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with underscore
     ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'

     #convert double underscores to single
     ret.gsub! /_+/,"_"

     #strip off leading/trailing underscore
     ret.gsub! /\A[_\.]+|[_\.]+\z/,""

     ret
  end

  
end
