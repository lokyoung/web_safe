class UploadFile < ApplicationRecord

  def self.file_delete name
    if File.exist? name
      File.delete name
    end
  end

end
