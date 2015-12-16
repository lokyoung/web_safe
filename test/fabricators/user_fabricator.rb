Fabricator(:student, class_name: :user) do
  id 1000
  name { Faker::Name.first_name }
  email 'abc2@qq.com'
  password_digest User.digest('password')
  type 'Student'
  stuclass { Fabricate(:stuclass_1) }
end

Fabricator(:teacher, class_name: :user) do
  id 1001
  name { Faker::Name.first_name }
  email 'abc@qq.com'
  password_digest User.digest('password')
  type 'Teacher'
end

Fabricator(:admin, class_name: :user) do
  id 1002
  name { Faker::Name.first_name }
  email 'abcdef@qq.com'
  password_digest User.digest('password')
  type 'AdminUser'
end
