# frozen_string_literal: true

module Repository::CheckHelper
  GITHUB_BLOB_TEMPLATE = 'https://github.com/{nickname}/{repo}/blob/{commit}/{path}{#lline}'

  def github_blob_link(check, reference_path)
    nickname, repo = check.repository.full_name.split '/'
    path = Addressable::Template.new(GITHUB_BLOB_TEMPLATE).expand(
      nickname: nickname, repo: repo, commit: check.commit, path: reference_path
    ).to_s
    link_to reference_path, path, target: '_blank', rel: 'noopener'
  end

  def github_blob_position_link(check, reference_path, location)
    nickname, repo = check.repository.full_name.split '/'
    path = Addressable::Template.new(GITHUB_BLOB_TEMPLATE).expand(
      nickname: nickname, repo: repo, commit: check.commit, path: reference_path, lline: "L#{location['line']}"
    ).to_s
    link_to "#{location['line']}:#{location['column']}", path, target: '_blank', rel: 'noopener'
  end
end
