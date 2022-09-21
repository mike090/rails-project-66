# frozen_string_literal: true

module RepositoryHelper
  CHECK_RESULT_ICONS = {
    check_passed: 'fa-regular fa-circle-check',
    errors_found: 'fa-solid fa-bug',
    fail: 'fa-regular fa-circle-xmark'
  }.freeze

  GITHUB_COMMIT_TEMPLATE = 'https://github.com/{nickname}/{repo}/commit/{commit}'

  def draw_check_result(check)
    return '' unless check.finished?

    results = check.result.map do |key, value|
      content_tag :div, class: :row do
        concat content_tag(:div, "#{key}: ", class: 'col-4 text-end')
        i_tag = content_tag :div, class: 'col' do
          content_tag(:i, '', class: CHECK_RESULT_ICONS[value['status'].to_sym], title: t(value['status']))
        end
        concat i_tag
      end
    end
    results.join
  end

  def check_reference_link(check)
    return '' unless check.finished?

    nickname, repo = check.repository.full_name.split '/'
    url = Addressable::Template.new(GITHUB_COMMIT_TEMPLATE).expand(
      nickname: nickname, repo: repo, commit: check.commit
    ).to_s
    link_to check.commit, url, target: '_blank', rel: 'noopener'
  end
end
