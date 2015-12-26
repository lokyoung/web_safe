module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      # logger.add_tags 'ActionCable', current_user.id
    end

    protected
    def find_verified_user
      # current_user = User.find_by(id: cookies.signed[:user_id])
      current_user = User.find session["user_id"]
      if current_user
        current_user
      else
        reject_unauthorized_connection
      end
    end

    def session
      session_key = Rails.application.config.session_options[:key]
      cookies.encrypted[session_key]
    end

    #def to_log(msg)
      #@path ||= Rails.root.join 'log/cable.log'
      #@log ||= File.new path, 'a+'
      #@log.puts msg
      #@log.flush
    #end
  end
end
