module Factory
  def hash_for_code(attributes={})
    { :title => 'This is a test', :comment => 'cool', :user_id => 1,
      :code => 'cool', :language => 'Ruby' }.merge(attributes)
  end
  
  def hash_for_refactor(attributes={})
    { :language => 'Ruby', :user_name => 'Marc', :comment => 'test', :code_id => 1 }.merge(attributes)
  end
  
  def hash_for_rating(attributes={})
    { :refactor_id => 1, :value => 1, :user_id => 2 }.merge(attributes)
  end
  
  def hash_for_user(attributes={})
    { :name => 'Dude', :identity_url => 'http://dude.myopenid.com' }.merge(attributes)
  end
    
  def method_missing(method, *args)
    case
    when name = method.to_s.match(/^create_(\w+)$/)
      returning new_instance(name[1], send("hash_for_#{name[1]}", *args)) do |instance|
        instance.save
      end
    when name = method.to_s.match(/^build_(\w+)$/)
      new_instance name[1], send("hash_for_#{name[1]}", *args)
    else
      super
    end
  end
  
  private
    def new_instance(name, attributes)
      instance = name.to_s.classify.constantize.new
      attributes.each_pair { |attr, value| instance.send "#{attr}=", value }
      instance
    end
  
end