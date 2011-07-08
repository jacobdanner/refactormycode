Factory.define :user do |u|
  u.name Faker::Name.name
  u.email Faker::Internet.email
end