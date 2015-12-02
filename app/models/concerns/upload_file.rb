module Concerns
  module UploadFile
    extend ActiveSupport::Concern

    def file_delete name
      if File.exist? name
        File.delete name
      end
    end

  end
end
