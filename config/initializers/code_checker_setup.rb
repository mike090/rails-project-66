# frozen_string_literal: true

Rails.application.config.to_prepare do
  CodeChecker.configurate do |config|
    config.checkers_path = Rails.root.join 'app/checkers'
  end
end
