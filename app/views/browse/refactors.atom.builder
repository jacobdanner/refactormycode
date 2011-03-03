atom_feed :url => url_for(:controller => 'browse', :action => @controller.action_name,
                          :only_path => false) do |feed|
  feed.title @title
  feed.updated @refactors.first ? @refactors.first.created_at : Time.now

  @refactors.each do |refactor|
    feed.entry refactor, code_refactor_url(refactor) do |entry|
      entry.title "[#{refactor.language}] On #{refactor.refactored_code.title}"
      entry.content markup(refactor.comment) + "\n" * 2 + content_tag(:pre, h(refactor.code)), :type => 'html'

      entry.author do |author|
        author.name refactor.user_name
        author.email refactor.user_email
      end
    end
  end
end