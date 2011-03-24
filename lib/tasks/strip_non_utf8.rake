desc 'Fix or remove strings which cause errors uploading DB to postgres\nThis must be run as "rake strip_non_utf8 RAILS_ENV=development" because defensio sucks'
task :strip_non_utf8 => :environment do

  require 'iconv'
  converter = Iconv.new('ASCII//IGNORE//TRANSLIT', 'UTF-8')

  [Notification,Refactor].map do |klass|
    klass.find(:all).each do |elt|
      elt.attributes.each do |attr,val|
        if !val.to_s.is_utf8?
          replacement_val = converter.iconv(val) rescue 'bad encoding'
          elt.update_attribute(attr, replacement_val)
        end
      end
    end
  end

end
