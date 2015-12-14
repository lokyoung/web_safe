class NullStorage
  attr_reader :uploader

  def initialize(uploader)
    @uploader = uploader
  end

  def identifier
    uploader.filename
  end

  def store!(_file)
    true
  end

  def retrieve!(_identifier)
    true
  end
end

CarrierWave.configure do |config|
  #if Rails.env.test?
    #config.storage NullStorage
  #end
  if Rails.env.development?
    config.storage :file
  end

  #def store_dir
  #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #end

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
end
