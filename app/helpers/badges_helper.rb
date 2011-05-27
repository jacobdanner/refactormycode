module BadgesHelper
  def badge_tag(user)
    content_tag :a, (
      image_tag("#{home_url}images/badge.gif", :style => 'border:0', :alt => 'RefactorMyCode.com') <<
      image_tag(position_badge_url(user), :style => 'border:0', :alt => "refactorer")
    ), :href => user_url(user), :title => "#{user.name} profile on RefactorMyCode.com"
  end
end
