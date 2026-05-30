require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TwitterClone
  class Application < Rails::Application
    config.load_defaults 7.1

    # Autoload lib directory
    config.autoload_lib(ignore: %w[assets tasks])

    # Timezone
    config.time_zone = "Istanbul"
    config.i18n.default_locale = :tr
    config.i18n.available_locales = [:tr, :en]

    # Generators config
    config.generators do |g|
      g.orm :active_record, primary_key_type: :bigint
      g.test_framework nil
      g.helper false
      g.assets false
    end
  end
end
