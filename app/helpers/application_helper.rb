module ApplicationHelper
  # Returns a 'human' formatted date string from a Date or Time object: "Yesterday", "Today" or  
  # "Tomorrow" where applicable (a la Mac OS X's Mail.app, amongst others), or otherwise the output of strftime  
  # for the given formatting string (the default, "%B %e, %Y", gives the American-style "Month [D]D, YYYY") 
  # Taken from: http://dev.rubyonrails.org/ticket/5792
  def human_date(date, format = "%B %e, %Y") 
    case Date.today - date.to_date 
      when  1 then "Yesterday" 
      when  0 then "Today" 
      when -1 then "Tomorrow" 
      else date.strftime(format) 
    end 
  end
  
  def scroll_to(title, id, options={})
    after_scroll = if highlight = options.delete(:highlight)
      "new Effect.Highlight('#{highlight}', { queue: 'end' });"
    end
    link_to(title, "\##{id}", { :onclick => "new Effect.ScrollTo('#{id}', { offset: -60 }); #{after_scroll} return false" }.merge(options))
  end
    
  def pluralize(count, word)
    case count
    when 0
      "No #{word}"
    else
      super
    end
  end
  
  # Behave like +link_to_remote+, but shows a spinner while the request is processing.
  #   link_to_remote_with_spinner 'Hi', :url => hi_path
  # You can specify the spinner and the container to hide
  #   link_to_remote_with_spinner 'Hi', :url => hi_path, :container_id => 'container', :spinner => 'spinner'
  def link_to_remote_with_spinner(title, options, html_options={})
    element_id = options.delete(:id) || ('link_to_' + title.underscore.tr(' ', '_'))
    container_id = options.delete(:container_id) || element_id
    
    returning '' do |out|
      unless spinner = options.delete(:spinner)
        spinner = "#{element_id}_spinner"
        out << image_tag('spinner.gif', :id => spinner, :class => 'spinner', :style => 'display:none')
      end
      options[:complete] = "$('#{spinner}').hide(); " + (options[:complete] || "$('#{container_id}').show()")
      
      out << link_to(title, { :loading => "$('#{container_id}').hide(); $('#{spinner}').show()" }.merge(options),
                            { :id => element_id }.merge(html_options), :remote => true)
    end
  end
  
  def markup(text)
    return '' if text.blank?
    auto_link simple_format(h(text)), :all, :target => '_blank'
  end
  
  def linkify(url)
    return '' if url.blank?
    ('http://' unless url =~ %r{http(s?)://}).to_s + url
  end
  
  def cachable_time_ago_in_words(from)
    id = "time_ago_#{from.to_i}"
    content_tag(:span, from.to_formatted_s(:long), :id => id) <<
    javascript_tag("$('#{id}').update(DateHelper.timeAgoInWords(#{(from.to_i * 1000).to_json}) + ' ago')")
  end
  
  def menu_item(name, title, path, options={})
    content_tag :li, link_to(title, path, :class => name.to_s + (" active" if current_page?(path)).to_s), options
  end
  
  def login_path
    super :return_to => request.request_uri
  end
  
  def wait_for_effects
    page << 'EffectWatcher.whenComplete(function() {'
    yield
    page << '});'
  end
end
