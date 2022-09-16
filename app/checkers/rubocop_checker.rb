# frozen_string_literal: true

require 'open3'
require 'json'
# require_relative 'code_checker'

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
            inspected_file_count: raw['summary']['inspected_file_count'],
            errors_count: raw['summary']['offense_count']
          }
        }
      )
    end
  end

  CodeChecker.register_checker self
end
