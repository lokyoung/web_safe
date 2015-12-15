Fabricator(:topic_1, from: :topic) do
  title { Faker::Name.name }
  content { Faker::Lorem.sentence }
  user { Fabricate(:student) }
end
