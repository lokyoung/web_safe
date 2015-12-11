module StuhomeworksHelper

  def notcreated? homework
    homework.stuhomeworks.where(user_id: current_user.id).blank?
  end

end
