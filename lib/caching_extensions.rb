module CachingExtensions
  module Sweeping
    def expire_all_fragments(glob)
      return unless perform_caching
    
      ActionController::Base.benchmark "Expired fragments: #{glob}" do
        FileUtils.rm_rf Dir["#{RAILS_ROOT}/tmp/cache/#{request.host_with_port.tr(':', '.')}/#{glob}"]
      end
    end
  
    def expire_pages(glob)
      return unless perform_caching

      ActionController::Base.benchmark "Expired pages: #{glob}" do
        FileUtils.rm_rf Dir["#{RAILS_ROOT}/public/#{glob}"]
      end
    end
  
    def expire_browser_pages
      expire_pages '/index.html'
      expire_pages 'codes'
      expire_pages 'refactorings'
      expire_pages 'refactorers'
      expire_pages 'tags'
    end
  end
  
  module Caching
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def cache_formatted_page(format, *actions)
        return unless perform_caching
        actions.each do |action|
          class_eval %(
            after_filter do |c|
              if c.action_name == '#{action}' && c.params[:format] == '#{format}'
                c.cache_page
              end
            end
          )
        end
      end
    end
  end
end
