require File.dirname(__FILE__) + '/../test_helper'

class CodeFormatterTest < Test::Unit::TestCase
  def test_simple_format
    assert_formats_to :simple_format, CodeFormatter.new("puts 'hi'", 'Ruby').to_html
  end
  
  def test_with_sections
    html = CodeFormatter.new(<<-EOS, 'Ruby').to_html
      ## My code
      def code
        1
      end
      
      ## Test
      def test_code
        assert_equal 1, code
      end
    EOS
    
    assert_formats_to :with_sections, html
  end
  
  def test_with_different_syntaxes
    html = CodeFormatter.new(<<-EOS, 'Ruby').to_html
      ## My code
      def code
        1
      end
      
      ## View [html_rails]
      <h1><%= @title %></h1>
      
      ## Javascript [javascript]
      var Page = {};
    EOS
    
    assert_formats_to :with_different_syntaxes, html
  end
  
  def test_split_in_sections
    formatter = CodeFormatter.new(<<-EOS, 'Ruby')
      ## My code
      def code
        1
      end
    
      ## Test
      def test_code
        assert_equal 1, code
      end
    EOS
    
    assert_equal 2, formatter.split_in_sections.size
    assert_equal 'My code', formatter.split_in_sections[0].title
    assert_match /^\s+def code/m, formatter.split_in_sections[0].code
    assert_equal 'Test', formatter.split_in_sections[1].title
    assert_match /^\s+def test_code/m, formatter.split_in_sections[1].code
  end
  
  def test_split_in_sections_with_no_sections
    formatter = CodeFormatter.new(<<-EOS, 'Ruby')
      def test_code
        assert_equal 1, code
      end    
    EOS
    
    assert_equal 1, formatter.split_in_sections.size
    assert_equal nil, formatter.split_in_sections[0].title
    assert_match /^\s+def test_code/m, formatter.split_in_sections[0].code
  end
  
  def test_split_in_sections_with_first_section_anonymous
    formatter = CodeFormatter.new(<<-EOS, 'Ruby')
      def code
        1
      end
    
      ## Test
      def test_code
        assert_equal 1, code
      end    
    EOS

    assert_equal 2, formatter.split_in_sections.size
    assert_equal nil, formatter.split_in_sections[0].title
    assert_match /^\s+def code/m, formatter.split_in_sections[0].code
    assert_equal 'Test', formatter.split_in_sections[1].title
    assert_match /^\s+def test_code/m, formatter.split_in_sections[1].code
  end
  
  def test_syntax_in_section
    formatter = CodeFormatter.new(<<-EOS, 'Ruby')
      def code
        1
      end
      
      ## View [html_rails]
      <h1><%= @title %></h1>
      
      ## Invalid syntax [invalid]
      <h1><%= @title %></h1>
    EOS

    assert_equal 'ruby', formatter.split_in_sections[0].syntax
    assert_equal 'View', formatter.split_in_sections[1].title
    assert_equal 'html_rails', formatter.split_in_sections[1].syntax
    assert_equal 'ruby', formatter.split_in_sections[2].syntax
  end
  
  def test_escape_language
    assert_equal 'ruby', CodeFormatter.escape_language('Ruby')
    assert_equal 'cs', CodeFormatter.escape_language('C#')
    assert_equal 'cpp', CodeFormatter.escape_language('C++')
  end

  def test_unescape_language
    assert_equal 'Ruby', CodeFormatter.unescape_language('ruby')
    assert_equal 'C#', CodeFormatter.unescape_language('cs')
    assert_equal 'C++', CodeFormatter.unescape_language('cpp')
  end
  
  def test_no_title
    formatter = CodeFormatter.new(<<-EOS, 'Ruby')
      ## View
      <h1><%= @title %></h1>
    EOS
    assert_no_match /h2/, formatter.to_html(:no_title => true)
  end
  
  private
    def fixture_root
      "#{RAILS_ROOT}/test/fixtures/code_formatter"
    end
  
    def assert_formats_to(fixture, html)
      assert_equal File.read("#{fixture_root}/#{fixture}"), html
    end
    
    def store_to(fixture, html)
      File.open("#{fixture_root}/#{fixture}", 'w') { |f| f << html }
    end
end