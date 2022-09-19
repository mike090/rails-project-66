class UpdateCheckPassed < ActiveRecord::Migration[6.1]
  def change
    Repository::Check.where.not(result: nil).each do |check|
      check.update(passed: check.result.all? { |_language, result| result['status'] == 'check_passed' })
    end
  end
end
