class CodesMailer < ActionMailer::Base
  include RefactorsHelper
  default_url_options[:host] = 'refactormycode.com'
  
  @@greetings = ['Holy cow', 'Aye caramba', 'Oh mama mia', 'Holy flying elephant']
  
  def new_refactoring(refactor, user_name, email)
    code = refactor.refactored_code
    
    recipients  email
    from        'notification@refactormycode.com'
    subject     "New refactoring on #{code.title}"
    body        :greeting => rand_greeting,
                :user_name => user_name,
                :code => code,
                :url  => code_refactor_url(refactor)
  end
  
  private
    def rand_greeting
      @@greetings.at(rand(@@greetings.size))
    end
end
