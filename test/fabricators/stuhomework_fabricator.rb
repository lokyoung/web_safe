Fabricator(:stuhomework) do
  id 10
  stuhomeworkfile Rack::Test::UploadedFile.new('./test/file/test.txt')
  homework
  user { Fabricate(:student) }
end

Fabricator(:stuhomework_1, class_name: :stuhomework) do
  id 11
  stuhomeworkfile Rack::Test::UploadedFile.new('./test/file/test_1.txt')
  #homework { Fabricate(:homework) }
  homework(fabricator: :homework)
  user_id 1
end

Fabricator(:stuhomework_2, class_name: :stuhomework) do
  id 12
  stuhomeworkfile Rack::Test::UploadedFile.new('./test/file/test_2.txt')
  homework_id 100
  user_id 2
end
