module UsersHelper
  # 获取用户头像
  def user_avatar user
    image_tag user.avatar_url, :width => 50
  end

  def user_type type
    case type
    when 'Student'
      '学生'
    when 'Teacher'
      '教师'
    when 'AdminUser'
      '管理员'
    end
  end
end
