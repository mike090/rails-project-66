# frozen_string_literal: true

module CodeChecker
  class Configuration
    attr_accessor :checkers_path
  end

  class << self
    def check(path, language)
      checker = checkers.fetch language
      checker.check(path)
    end

    def register_checker(checker)
      Rails.logger.debug { "#{checker} registration..." }
      checkers[checker.language] = checker
    end

    def languages
      checkers.keys
    end

    def configurate
      @config ||= Configuration.new
      yield @config if block_given?
    end

    private

    def checkers
      unless @checkers
        @checkers = {}
        if @config
          Dir["#{@config.checkers_path}/*.rb"].sort.each { |file| require file }
        end
      end
      @checkers
    end
  end
end
