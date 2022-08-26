# frozen_string_literal: true

module Web
  class HomeController < ApplicationController
    def index
      redirect_to repositories_path if current_user.is_a? User
    end
  end
end
