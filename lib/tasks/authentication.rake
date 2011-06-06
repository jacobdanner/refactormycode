desc "Migrate old user indentify_url to new authentication model."
task :migrate_auth_url => :environment do
  User.all.each do |user|
    puts ">>>>>>>>USER ID:#{user.id}<<<<<<<<<"
    next unless user.authentications.blank?
    
    auth_hash = {}
    
    if user.identity_url.include?("myopenid.com")
      auth_hash.merge!({:provider => "myopenid", :uid => user.identity_url})
    elsif user.identity_url.include?("www.google.com/accounts/o8/")
      auth_hash.merge!({:provider => "google", :uid => user.identity_url})
    else
      auth_hash.merge!({:provider => "openid", :uid => user.identity_url})
    end
    puts "============>> Provider:#{auth_hash[:provider]}"
    puts "============>> Identity URL:#{auth_hash[:uid]}"
    user.authentications.create!(auth_hash.merge!({:uname => user.name, :uemail => user.email}))
    puts ">>>>>>>>FINISHED ID:#{user.id}<<<<<<<<<"
  end
end