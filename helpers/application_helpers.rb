module ApplicationHelpers

  def css(*stylesheets)
      stylesheets.map do |stylesheet|
        "<link href=\"/stylesheets/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
      end.join
  end

  def js(*javascripts)
    javascripts.map do |javascript|
      "<script src=\"/javascripts/#{javascript}.css\" media=\"screen, projection\"/>"
    end.join
  end

  def current?(path='/')
    request.path_info==path ? "current":  nil
  end
end
