Fabricator(:announce_1, from: :announce) do
  title { Faker::Name.name }
  content { Faker::Lorem.sentence }
  user
end
