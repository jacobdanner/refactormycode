atom_feed :url => user_friends_url(@user) do |feed|
  feed.title "#{@user.name} friends"
  feed.updated @items.first ? @items.first.created_at : Time.now
  
  atom_feed_entries feed, @items
end