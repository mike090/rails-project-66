# frozen_string_literal: true

module CodeChecker
  class << self
    def check(path, language)
      checker = checkers.fetch language
      checker.check(path)
    end

    def register_checker(checker)
      checkers[checker.language] = checker
    end

    def languages
      checkers.keys
    end

    private

    def checkers
      @checkers ||= {}
    end
  end
end

# require 'rubocop_checker'
# require 'eslint_checker'
