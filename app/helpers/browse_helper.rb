module BrowseHelper
  def magic_url_for(item)
    case item
    when Code
      code_url(item)
    when Refactor
      refactor_url(item.refactored_code, item)
    end
  end
  
  def atom_feed_entries(feed, items)
    items.each do |item|
      feed.entry item, magic_url_for(item) do |entry|
        entry.title "[#{item.language}] #{item.title}"
        entry.content markup(item.comment) + "\n" * 2 + content_tag(:pre, h(item.code)), :type => 'html'
        entry.author do |author|
          author.name item.respond_to?(:user_name) ? item.user_name : item.user.name
          author.email item.respond_to?(:user_name) ? item.user_email : item.user.email
        end
      end
    end
  end
end
