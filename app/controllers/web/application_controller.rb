# frozen_string_literal: true

module Web
  class ApplicationController < ::ApplicationController
    include ::Authentication

    add_flash_types :success, :warning, :danger, :info
  end
end
