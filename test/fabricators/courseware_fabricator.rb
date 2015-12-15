Fabricator(:courseware_1, from: :courseware) do
  id 11
  title 'course 1'
  description 'des 1'
  coursefile Rack::Test::UploadedFile.new('./test/file/test_1.txt')
  user { Fabricate(:teacher) }
end

Fabricator(:courseware_2, from: :courseware) do
  id 12
  title 'course 2'
  description 'des 2'
  coursefile Rack::Test::UploadedFile.new('./test/file/test_2.txt')
  user { Fabricate(:teacher) }
end
