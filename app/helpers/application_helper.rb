# frozen_string_literal: true

module ApplicationHelper
  ICON_LINK_CLASS = 'btn btn-sm btn-outline-dark me-1'

  BUTTON_LINK_CLASS = 'btn btn-outline-dark me-2'

  ACTIONS_ICONS = {
    show: 'fa-solid fa-magnifying-glass',
    update: 'fa-solid fa-rotate',
    check: 'fa-solid fa-check-double',
    refresh: 'fa-solid fa-rotate',
    back: 'fa-solid fa-rotate-left'
  }.freeze

  ACTIONS_HTTP_METODS = {
    show: :get,
    update: :patch,
    check: :post,
    refresh: :get,
    back: :get
  }.freeze

  def icon_action_link(action, link_options)
    hint = link_options.delete :hint
    disabled = link_options.delete :disabled
    url_options = { action: action }.merge link_options
    path = url_for url_options
    link_class = disabled ? "#{ICON_LINK_CLASS} disabled" : ICON_LINK_CLASS
    content_tag :span, title: hint do
      link_to path, class: link_class, method: ACTIONS_HTTP_METODS[action] do
        content_tag :i, '', class: ACTIONS_ICONS[action]
      end
    end
  end

  def button_action_link(action, link_options)
    caption = link_options.delete :caption
    disabled = link_options.delete :disabled
    url_options = { action: action }.merge link_options
    path = url_for url_options
    link_class = disabled ? "#{BUTTON_LINK_CLASS} disabled" : BUTTON_LINK_CLASS
    link_to path, class: link_class, method: ACTIONS_HTTP_METODS[action] do
      (content_tag :span, class: 'me-2' do
        content_tag :i, '', class: ACTIONS_ICONS[action]
      end) + caption
    end
  end

  def allow?(_action, _resource)
    true
    # policy(resource).public_send("#{action}?") && aasm_allow?(action, resource)
  end

  def colon(str)
    "#{str}:"
  end

  def caption_for(model, attribute)
    model.human_attribute_name attribute
  end

  private

  def aasm_allow?(action, resource)
    return true unless resource.class.include? AASM

    return true unless action.in?(resource.class.aasm.events.map(&:name))

    resource.aasm.may_fire_event? action
  end
end
