require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Reloading desativado para produção
  config.enable_reloading = false

  # Carregamento antecipado de código
  config.eager_load = true

  # Relatórios completos de erro desativados
  config.consider_all_requests_local = false

  # Caching ativado
  config.action_controller.perform_caching = true

  # Configurações de servidor de arquivos estáticos
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Serviço de armazenamento ativo
  config.active_storage.service = :local

  # Forçar SSL
  config.force_ssl = true

  # Tags de log
  config.log_tags = [ :request_id ]

  # Configuração do logger
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  # Nível de log
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Relatórios de depreciação desativados
  config.active_support.report_deprecations = false

  # Configuração de cache
  config.cache_store = :memory_store

  # Adaptador de filas para Active Job
  config.active_job.queue_adapter = :inline

  # Configurações de fallback de internacionalização
  config.i18n.fallbacks = true

  # Não descarregar esquema após migrações
  config.active_record.dump_schema_after_migration = false

  # Configuração do pipeline de ativos
  config.assets.js_compressor = :terser
  config.assets.css_compressor = nil
  config.assets.compile = false # Desative para evitar compilação dinâmica
  config.assets.digest = true # Gera nomes únicos para ativos
end
