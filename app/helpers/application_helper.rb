module ApplicationHelper
  include LetterAvatar::AvatarHelper
  include SessionsHelper

  def full_title(page_title = '')
    base_title = '花椒网安'
    if(page_title.empty?)
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
