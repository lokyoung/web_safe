Fabricator(:user) do
  id 1000
  name { Faker::Name.name }
  email 'abc@qq.com'
  password User.digest('password')
  type 'AdminUser'
end
