# frozen_string_literal: true

class EslintChecker
  class << self
    def language
      :JavaScript
    end

    def linter
      'Eslint'
    end

    def check(path)
      stdout, stderr, status = (Open3.capture3 "./node_modules/eslint/bin/eslint.js #{path} -c .eslint_checker.yml -f json --no-eslintrc")
      case status.exitstatus
      when 0
        { status: :check_passed }.merge parse(stdout)
      when 1
        { status: :errors_found }.merge parse(stdout)
      else
        { status: :fail, summary: { linter: linter, error_message: stderr } }
      end
    end

    private

    def parse(raw)
      raw = JSON.parse raw
      errors = raw.select { |file| file['messages'].any? }.map do |file|
        {
          path: file['filePath'],
          issues: file['messages'].map do |message|
            {
              message: message['message'],
              rule: message['ruleId'],
              location: message.slice('line', 'column').transform_keys(&:to_sym)
            }
          end
        }
      end

      result = errors.empty? ? {} : { errors: errors }

      result.merge(
        {
          summary: {
            linter: linter,
            inspected_file_count: raw.count,
            errors_count: raw.sum { |file| file['errorCount'] }
          }
        }
      )
    end
  end

  Rails.logger.debug { "... egister checker: #{self.class}" }
  CodeChecker.register_checker EslintChecker unless EslintChecker.language.in? CodeChecker.languages
end
