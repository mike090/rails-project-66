# frozen_string_literal: true

module CodeChecker
  class << self
    def check(path, language)
      checker = checkers.fetch language
      checker.check(path)
    end

    def register_checker(checker)
      Rails.logger.debug { "... register checker: #{checker} ..." }
      checkers[checker.language] = checker
    end

    def languages
      checkers.keys
    end

    def load_checkers(path)
      Dir["#{path}/*.rb"].each { |file| require file }
    end

    private

    def checkers
      @checkers ||= {}
    end
  end

  CodeChecker.load_checkers(Rails.root.join('checkers'))
end
