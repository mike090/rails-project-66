frozen_string_literal: true

require 'open3'
require 'json'
require_relative 'code_checker'

class RubocopChecker
  class << self
    def language
      'ruby'
    end

    def name
      'Rubocop'
    end

    def check(path)
      stdout, stderr, status = (Open3.capture3 "bundle exec rubocop #{path} -c .rubocop_checker.yml -f j")
      if status.exitstatus == 2
        { status: :fail, error_message: stderr }
      else
        { status: :success, result: parse(stdout) }
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

      result = errors.empty? ? {} : { details: errors }
      result.merge(
        {
          inspected_file_count: raw['summary']['inspected_file_count'],
          errors_count: raw['summary']['offense_count']
        }
      )
    end
  end

  CodeChecker.register_checker self
end
