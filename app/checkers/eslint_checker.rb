# frozen_string_literal: true

require 'open3'
require 'json'
# require_relative 'code_checker'

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
        { linter: linter, status: :check_passed }.merge parse(stdout)
      when 1
        { linter: linter, status: :errors_found }.merge parse(stdout)
      else
        { linter: linter, status: :fail, error_message: stderr }
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
            inspected_file_count: raw.count,
            errors_count: raw.sum { |file| file['errorCount'] }
          }
        }
      )
    end
  end

  CodeChecker.register_checker self
end
