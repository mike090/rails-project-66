# frozen_string_literal: true

module Web
  class ApplicationController < ::ApplicationController
    include ::Authentication
    include ::Authorization

    add_flash_types :success, :warning, :danger, :info
  end
end
