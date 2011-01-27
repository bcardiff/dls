module NotifierHelper
  def dd(entity, attribute)
    raw("<b>#{h entity.class.human_attribute_name(attribute)}</b> #{h entity.send(attribute)}<br/>")
  end
end