module UsersHelper
  def avatar(user)
    param = user.respond_to?(:email) ? user.email : user
    param ||= 'test@example.com'

    link_to_unless !user.is_a?(User), 
      image_tag(gravatar_url_for(param), :class => 'avatar', :size => '80x80'),
      (user_path(user) if user.is_a?(User))
  end

  def friend_avatar(friend)
    link_to image_tag(gravatar_url_for(friend.email), :size => "20x20"), user_path(friend), :title => h(friend.name)
  end

  def friend?(user)
    current_user.friends.include?(user)
  end

  require 'digest/md5'
  def gravatar_url_for(email, options = {})
    addr = email.downcase
    hash = Digest::MD5.hexdigest addr
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def position(user)
    render :partial => 'users/position', :locals => { :user => user }
  end

  def link_to_website(user)
    link_to user.website, linkify(user.website) unless user.website.blank?
  end
end
