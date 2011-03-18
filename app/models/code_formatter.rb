class CodeFormatter
  cattr_reader :languages
  @@languages = %w(Ruby PHP JavaScript ActionScript Java C C++ C# VB.NET Python Perl Lisp Erlang Haskell Bash Delphi).sort
  
  cattr_reader :syntaxes
  @@syntaxes = @@languages
  
  def initialize(code, language)
    @code = code
    @language = language
  end
  
  def syntax
    case @language
    when 'Bash'   then 'shell-unix-generic'
    when 'C++'    then 'c++'
    when 'VB.NET' then 'asp_vb.net'
    when 'Delphi' then 'pascal'
    else self.class.escape_language @language
    end
  end
    
  def valid_syntax?(syntax)
    self.class.syntaxes.include? syntax
  end
  
  def to_html(options={})
    return '' if @code.blank?
    
    html_escapes = { '&' => '&amp;', '"' => '&quot;', '>' => '&gt;', '<' => '&lt;' }
    html_forbidden = html_escapes.keys

    split_in_sections.collect do |section|
      "<pre language='#{section.syntax}'>" + section.code.gsub(/[#{html_forbidden}]/) { |c| html_escapes[c] }.strip + "</pre>"
    end.join("\n")
  end

  def to_embeded_html
    classes = {
      :code => 'overflow:auto;border:solid 1px #ccc;background:#000;color:#F8F8F8',
      :lines => 'float:left;margin:0 10px;border-right:0;color:#666;',
      :title => 'margin:0;padding:4px 6px;font-size:12px;float:right;'
    }.merge(Style::EMBEDED)
    html = to_html
    html.gsub! '<h2>', '<span class="title">'
    html.gsub! '</h2>', '</span>'
    classes.each_pair do |className, style|
      html.gsub! %Q{class="#{className}"}, %Q{style="#{style}"}
    end
    html
  end
  
  def split_in_sections
    current_section = Section.new(syntax)
    sections = [current_section]
    
    @code.split("\n").each do |line|
      if matches = line.chomp.match(/^\s*##\s?(.+?)(?:\s+\[(.+)\])?$/)
        current_section = Section.new(valid_syntax?(matches[2]) ? matches[2] : syntax, matches[1])
        sections << current_section
      else
        current_section << line
      end
    end
    
    # Remove the first anonymous section if empty
    sections.delete_at(0) if sections[0].code.gsub("\n", '').empty? && sections.size > 1
    
    sections
  end
  
  class Section
    attr_accessor :code, :title, :syntax
    
    def initialize(syntax, title=nil)
      @syntax = syntax
      @title = title
      @code = ''
    end
    
    def <<(code)
      @code << code << "\n"
    end
  end
  
  def self.escape_language(language)
    case language
    when 'C#'     then 'cs'
    when 'C++'    then 'cpp'
    when 'VB.NET' then 'vb'
    else language.downcase
    end
  end
  
  def self.unescape_language(language)
    case language
    when 'cs'          then 'C#'
    when 'cpp'         then 'C++'
    when 'php'         then 'PHP'
    when 'javascript'  then 'JavaScript'
    when 'actioncript' then 'ActionScript'
    when 'vb'          then 'VB.NET'
    else language.titleize
    end
  end
end
