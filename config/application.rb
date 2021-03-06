require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebSafe
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    LetterAvatar.setup do |config|
      config.cache_base_path = 'public/system/lets' # default is 'public/system'
      config.colors_palette = :iwanthue
    end

    # 处理AJAX兼容
    config.action_view.embed_authenticity_token_in_remote_forms = true
    # 使用fabrication代替fixture
    config.generators do |g|
      g.test_framework      :minitest, fixture_replacement: :fabrication
      g.fixture_replacement :fabrication, dir: "test/fabricators"
    end

    # observer
    #config.active_record.observers = :answer_observer

    # RAILS 5 UPDATE
    ActiveSupport.halt_callback_chains_on_return_false = false
  end
end
