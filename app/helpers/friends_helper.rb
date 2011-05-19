module FriendsHelper
  def auto_discovery_link_tag_for_friends(user=@user)
    auto_discovery_link_tag :atom, user_friends_url(user, :atom), { :title => "#{user.name} friends" }
  end
end
