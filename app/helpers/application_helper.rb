# frozen_string_literal: true

module ApplicationHelper
  ICON_LINK_CLASS = 'btn btn-sm btn-outline-dark me-1'

  BUTTON_LINK_CLASS = 'btn btn-outline-dark me-2'

  ACTIONS_ICONS = {
    show: 'fa-solid fa-magnifying-glass',
    update: 'fa-brands fa-github',
    check: 'fa-solid fa-check-double',
    refresh: 'fa-solid fa-rotate',
    back: 'fa-solid fa-rotate-left',
    new: 'fa-solid fa-asterisk'
  }.freeze

  ACTIONS_HTTP_METODS = {
    show: :get,
    update: :patch,
    check: :post,
    refresh: :get,
    back: :get
  }.freeze

  def http_method_for(action)
    ACTIONS_HTTP_METODS[action]
  end

  def action_icon(action)
    ACTIONS_ICONS[action]
  end

  def resource_url_options(resource, action, **path_options)
    id_param_name = path_options.delete(:pass_resource_id_as) || :id
    { action: action, id_param_name => resource.id }.merge path_options
  end

  def icon_action_link(action, **link_options)
    hint = t(action)
    link_class = class_names ICON_LINK_CLASS, { disabled: link_options.delete(:disabled) }
    path = url_for link_options

    content_tag :span, title: hint do
      link_to path, class: link_class, method: http_method_for(action) do
        content_tag :i, '', class: action_icon(action)
      end
    end
  end

  def button_action_link(action, **link_options)
    caption = t(action)
    link_class = class_names BUTTON_LINK_CLASS, { disabled: link_options.delete(:disabled) }
    path = url_for link_options

    link_to path, class: link_class, method: http_method_for(action) do
      span = content_tag :span, class: 'me-2' do
        content_tag :i, '', class: action_icon(action)
      end
      concat span
      concat caption
    end
  end

  def allow?(action, resource)
    resource = resource.object if resource.is_a? Draper::Decorator
    policy(resource).public_send("#{action}?") && aasm_allow?(action, resource)
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
