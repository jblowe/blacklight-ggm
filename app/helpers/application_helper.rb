module ApplicationHelper

  def render_image_link options = {}
    # return a link to an image
    content_tag(:div) do
      options[:value].collect do |filename|
        filename = filename.gsub('#', '%23')
        content_tag(:a, 'filename',
          href: "file:///#{filename}",
          style: 'padding: 3px;',
          class: 'hrefclass')
      end.join.html_safe
    end
  end

  def render_images(options = {})
    # Return a bunch of <img> elements
    cards = options[:value].collect do |imagename|
      content_tag(:div, class: 'card', style: 'width: 18rem; float: left;') do
        image_tag = content_tag(:img, '', src: imagename, class: 'card-img-top')
        card_body = content_tag(:div, class: 'card-body') do
          content_tag(:p, imagename.gsub(/\/.*?\//,'').gsub('.thumbnail.jpg',''), class: 'card-text')
        end
        image_tag + card_body
      end
    end
    cards.join.html_safe
  end

end
