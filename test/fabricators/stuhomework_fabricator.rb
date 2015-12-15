Fabricator(:stuhomework) do
  id 10
  stuhomeworkfile Rack::Test::UploadedFile.new('./test/file/test.txt')
  homework
  user { Fabricate(:student) }
end

Fabricator(:stuhomework_1, from: :stuhomework) do
  id 11
  stuhomeworkfile Rack::Test::UploadedFile.new('./test/file/test_1.txt')
  homework_id 1
  user_id 1
end

Fabricator(:stuhomework_2, from: :stuhomework) do
  id 12
  stuhomeworkfile Rack::Test::UploadedFile.new('./test/file/test_2.txt')
  homework_id 1
  user_id 2
end
