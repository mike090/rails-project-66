class UpdateRepositoriesCloneUrl < ActiveRecord::Migration[6.1]
  def change
    Repository.all.each do |repo|
      repo.update Octokit.client.repo(repo.github_id).to_h.slice :clone_url
    end
  end
end
