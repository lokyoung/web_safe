Fabricator(:announce_1, class_name: :announce) do
  title { Faker::Name.name }
  content { Faker::Lorem.sentence }
  user_id 1001
end
