Fabricator(:homework) do
  id 10
  title "fah"
  description "fa des"
  homeworkfile Rack::Test::UploadedFile.new('./test/file/test.txt')
  user_id 1
end
