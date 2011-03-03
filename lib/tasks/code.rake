desc 'Extract style from css files into Ruby code'
task :extract_style do
  css = File.read 'public/stylesheets/code.css'
  css.gsub! "{\n", '{'
  css.gsub! ";\n", ';'
  
  output = ''
  
  output << "module Style\n"
  output << "  EMBEDED = {\n"
  output << css.grep(/\.code pre \.(\w+) \{(.*)\}/) do
    "    #{(':' + $1).ljust(25)} => '#{$2.delete(' ')}'"
  end.join(",\n")
  output << "\n  }\n"
  output << "end"
  
  File.open("app/models/style.rb", 'w') { |f| f << output }
end
