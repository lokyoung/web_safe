class UploadFile < ActiveRecord::Base

  def self.file_delete name
    if File.exist? name
      File.delete name
    end
  end

end
