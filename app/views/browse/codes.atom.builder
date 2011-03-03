atom_feed :url => url_for(:controller => 'browse', :action => @controller.action_name,
                          :only_path => false) do |feed|
  feed.title @title
  feed.updated @codes.first ? @codes.first.updated_at : Time.now

  @codes.each do |code|
    feed.entry code, code_url(code) do |entry|
      entry.title "[#{code.language}] #{code.title}"
      entry.content markup(code.comment) + "\n" * 2 + content_tag(:pre, h(code.code)), :type => 'html'

      entry.author do |author|
        author.name code.user.name
        author.email code.user.email
      end
    end
  end
end