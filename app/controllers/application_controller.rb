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
