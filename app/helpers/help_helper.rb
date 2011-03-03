module HelpHelper
  def formate_shell_cmd(cmd)
    format_code cmd, 'shell-unix-generic'
  end
  
  def curl(method, url, args=nil)
    formate_shell_cmd "curl -H 'Accept: application/xml' -H 'Content-Type: text/xml' -X #{method.to_s.upcase} #{url} #{args}"
  end
  
  def format_block(language, &block)
    concat format_code(capture(&block), language), block.binding
  end
end
