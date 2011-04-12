module CodesHelper
  def format_code(code, language, options={})
    CodeFormatter.new(code, language).to_html(options)
  end
    
  def truncate_lines(text, size)
    return if text.blank?
    lines = text.split("\n")
    lines[0, size].join("\n") + ("\n..." if lines.size > size).to_s
  end
  
  def language_css(language)
    CodeFormatter.escape_language language
  end
  
  def tag_list(code)
    results = ', tagged with ' + (code.tag_list.collect { |tag| link_to(h(tag), tags_path(tag)) } * ', ') unless code.tag_list.empty?
    results.html_safe
  end
end
