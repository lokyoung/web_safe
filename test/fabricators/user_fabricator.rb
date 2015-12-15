Fabricator(:user) do
  id 1000
  name { Faker::Name.first_name }
  email 'abc1@qq.com'
  password User.digest('password')
  type 'Student'
end

Fabricator(:student, from: :user) do
  id 1000
  name { Faker::Name.first_name }
  email 'abc2@qq.com'
  password User.digest('password')
  type 'Student'
  stuclass
end

Fabricator(:teacher, from: :user) do
  id 1001
  name { Faker::Name.first_name }
  email 'abc@qq.com'
  password User.digest('password')
  type 'Teacher'
end

Fabricator(:admin, from: :user) do
  id 1002
  name { Faker::Name.first_name }
  email 'abcdef@qq.com'
  password User.digest('password')
  type 'AdminUser'
end
