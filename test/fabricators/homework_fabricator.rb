Fabricator(:homework) do
  id 100
  title "fah"
  description "fa des"
  homeworkfile Rack::Test::UploadedFile.new('./test/file/test.txt')
  user_id 1
end

