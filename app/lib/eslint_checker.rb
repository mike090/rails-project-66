# frozen_string_literal: true

require 'open3'
require 'json'
require_relative 'code_checker'

class EslintChecker

  class << self
    def language
      'javascript'
    end

    def name
      'Eslint'
    end

    def check(path)
      stdout, stderr, status = (Open3.capture3 "npx eslint #{path} -c .eslint_checker.yml -f json --no-eslintrc")
      if status.exitstatus == 2
        { status: :fail, error_message: stderr }
      else
        { status: :success, result: parse(stdout) }
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

      result = errors.empty? ? {} : { detail: errors }

      result.merge(
        {
          inspected_file_count: raw.count,
          errors_count: raw.sum { |file| file['errorCount'] }
        }
      )
    end
  end

  CodeChecker.register_checker self
end
