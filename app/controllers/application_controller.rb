class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include StuhomeworksHelper
  helper_method :unread_notify_count

  def unread_notify_count
    return 0 if current_user.blank?
    @unread_notify_count ||= current_user.notifications.unread.count
  end

  # 删除文件
  #def file_delete name
  #if File.exist? name
  #File.delete name
  #end
  #end

  def file_delete name
    file = name.to_s
    if File.exist? file
      File.delete file
    end
  end


  private

  def teacher_admin_user
    unless teacher_admin?
      flash[:danger] = '权限不够，无法操作'
      redirect_to root_url
    end
  end

  def teacher_user
    redirect_to(root_url) unless teacher?
  end

  def send_notice user
    ActionCable.server.broadcast "user:#{user.id}", { body: user.notifications.unread.count.to_s }
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "请先登录"
      redirect_to login_url
    end
  end

  def correct_user user
    unless (current_user == user)|| admin?
      flash[:warning] = '请不要尝试修改他人的内容'
      redirect_to root_url
    end
  end

  # Notification相关方法
  def create_answer_notification answer
    Notification.create(user_id: answer.question.user_id, title: "<a href=#{user_url(answer.user)}>#{answer.user.name}</a>在问题<a href=#{question_url(answer.question)}>#{answer.question.title}</a>中回复:", content: "#{answer.content}", unread: true)
    send_notice answer.question.user
  end

  def create_comment_notification comment
    case comment.comment_to
    when 'Topic'
      Notification.create(user_id: comment.topic.user_id, title: "<a href=#{user_url(comment.user)}>#{comment.user.name}</a>在话题<a href=#{topic_url(comment.topic)}>#{comment.topic.title}</a>中回复:", content: "#{comment.content}", unread: true)
      send_notice comment.topic.user
    when 'Answer'
      Notification.create(user_id: comment.answer.user_id, title: "<a href=#{user_url(comment.user)}>#{comment.user.name}</a>在您对问题<a href=#{question_url(comment.answer.question)}>#{comment.answer.question.title}</a>发表的答案中评论:", content: "#{comment.content}", unread: true)
      send_notice comment.answer.user
    end
  end

  #def create_followers_notification item
    #current_user.followers.each do |user|
      #case item.class.to_s
      #when 'Question'
        #Notification.create(user_id: user.id, title: "你关注的用户<a href=#{user_url(current_user)}>#{current_user.name}</a>发布新问题", content: "<a href=#{question_url(item)}>#{item.title}</a>", unread: true)
      #when 'Answer'
        #Notification.create(user_id: user.id, title: "你关注的用户<a href=#{user_url(current_user)}>#{current_user.name}</a>在问题<a href=#{question_url(item.question)}>#{item.question.title}</a>中回复:", content: "#{item.content}", unread: true)
      #when 'Topic'
        #Notification.create(user_id: user.id, title: "你关注的用户<a href=#{user_url(current_user)}>#{current_user.name}</a>发布新话题", content: "<a href=#{topic_url(item)}>#{item.title}</a>", unread: true)
      #when 'Courseware'
        #Notification.create(user_id: user.id, title: "你关注的用户<a href=#{user_url(current_user)}>#{current_user.name}</a>发布新课件", content: "<a href=#{courseware_url(item)}>#{item.title}</a>", unread: true)
      #when 'Comment'
        #case item.comment_to
        #when 'Topic'
          #Notification.create(user_id: user.id, title: "你关注的用户<a href=#{user_url(current_user)}>#{current_user.name}</a>在话题<a href=#{topic_url(item.topic)}>#{item.topic.title}</a>中评论:", content: "#{item.content}", unread: true)
        #when 'Answer'
          #Notification.create(user_id: user.id, title: "你关注的用户<a href=#{user_url(current_user)}>#{current_user.name}</a>在问题<a href=#{question_url(item.answer.question)}>#{item.answer.question.title}</a>中评论:", content: "#{item.content}", unread: true)
        #end
      #end
      #send_notice user
    #end
  #end

  # 动态定义简单的index, edit, :show, :new action
  def self.normal_item(*args)
    if args.include? :index
      define_method(:index){
        items = params[:controller]
        self.class.send(:attr_accessor, items)
        self.send( "#{item}=", items.singularize.capitalize.constantize.page(params[:page]))
      }
    end
    if args.include? :new
      define_method(:new){
        item = params[:controller].singularize
        self.class.send(:attr_accessor, item)
        self.send("#{item}=", item.capitalize.constantize.new)
      }
    end

    if args.include? :show
      define_method(:show){
        item = params[:controller].singularize
        self.class.send(:attr_accessor, item)
        self.send(item + "=", item.capitalize.constantize.find(params[:id]))
      }
    end

    if args.include? :edit
      define_method(:edit){
        item = params[:controller].singularize
        self.class.send(:attr_accessor, item)
        self.send(item + "=", item.capitalize.constantize.find(params[:id]))
      }
    end

    #if args.include? :destroy
    #define_method(:destroy){
    #item = params[:controller].singularize
    #self.class.send(:attr_accessor, item)
    #self.send(item + "=", item.capitalize.constantize.find(params[:id]).destroy)
    #}
    #end
  end

end
