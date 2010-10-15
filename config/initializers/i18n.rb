require 'i18n'
module I18n  # Reopen library module
  def self.fallback_default_exception_handler(exception, locale, key, options)
    # Recursive case should fall through
    if exception.kind_of?(MissingTranslationData) && locale != self.default_locale
      begin
        return translate(key, options.merge(:locale => self.default_locale, :raise => true))
          # Always raise so we can catch it
      rescue MissingTranslationData
        # Fall through and handle as below
      end
    end
    send :default_exception_handler, exception, locale, key, options
  end

  def self.translate_default(key, options = {})
    translate(key, options.merge(:default=>key))
  end

end

I18n.exception_handler = :fallback_default_exception_handler
