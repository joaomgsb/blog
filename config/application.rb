require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Adiciona o diretório `lib` ao autoload paths
    config.autoload_paths << Rails.root.join("lib")

    # Ignora subdiretórios específicos dentro de `lib`
    ignored_dirs = %w[assets tasks]
    ignored_dirs.each do |dir|
      config.eager_load_paths.delete(Rails.root.join("lib", dir))
    end

    # Configuração de idioma e fuso horário
    config.i18n.default_locale = :'pt-BR'
    config.time_zone = "Brasilia"
  end
end
