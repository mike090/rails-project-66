# frozen_string_literal: true

class RubocopChecker
  class << self
    def language
      :Ruby
    end

    def linter
      'Rubocop'
    end

    def check(path)
      stdout, stderr, status = (Open3.capture3 "bundle exec rubocop #{path} -c .rubocop_checker.yml -f j")
      case status.exitstatus
      when 0
        { status: :check_passed }.merge parse(stdout)
      when 1
        { status: :errors_found }.merge parse(stdout)
      else
        {
          status: :fail,
          summary:
          {
            linter: linter,
            error_message: stderr
          }
        }
      end
    end

    private

    def parse(raw)
      raw = JSON.parse raw
      errors = raw['files'].select do |file|
        file['offenses'].any?
      end
      errors.map! do |file|
        {
          path: file['path'],
          issues: file['offenses'].map do |offense|
            {
              message: offense['message'],
              rule: offense['cop_name'],
              location: offense['location'].slice('line', 'column').transform_keys(&:to_sym)
            }
          end
        }
      end

      result = errors.empty? ? {} : { errors: errors }
      result.merge(
        {
          summary: {
            linter: linter,
            inspected_file_count: raw['summary']['inspected_file_count'],
            errors_count: raw['summary']['offense_count']
          }
        }
      )
    end
  end

  Rails.logger.debug { "... register checker: #{self.class}" }
  CodeChecker.register_checker(RubocopChecker) unless RubocopChecker.language.in? CodeChecker.languages
end
