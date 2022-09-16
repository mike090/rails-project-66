class TransformLinterReports < ActiveRecord::Migration[6.1]
  def change
   Repository::Check.all.each do |check|
      check.result = check.result.to_h do |language, result|
        result['summary'] = { linter: result.delete('linter')}.merge(result['summary'])
        [language, result]
      end
      check.save
    end
  end
end
