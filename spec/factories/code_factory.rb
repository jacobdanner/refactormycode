Factory.define :code do |c|
  c.association :user
  c.title 'Misc'
  c.comment 'misc'
  c.code 'class Awesomeness;end'
  c.language 'Ruby'
end
