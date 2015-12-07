class AnswersController < ApplicationController
  before_action :logged_in
  
  def index
  end

  def new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))
    if @answer.save
      flash[:success] = '创建答案成功'
      # 向当前问题发布者发送公告
      Notification.create(user_id: @question.user_id, title: "<a href=#{user_url(current_user)}>#{current_user.name}</a>在问题<a href=#{question_url(@question)}>#{@question.title}</a>中回复:", content: "#{@answer.content}", unread: true)
      ActionCable.server.broadcast "user:#{@question.user_id}", { body: @question.user.notifications.unread.count.to_s }
      # 向关注者发送公告
      current_user.followers.each do |user|
        Notification.create(user_id: user.id, title: "你关注的用户<a href=#{user_url(current_user)}>#{current_user.name}</a>在问题<a href=#{question_url(@question)}>#{@question.title}</a>中回复:", content: "#{@answer.content}", unread: true)
        ActionCable.server.broadcast "user:#{user.id}", { body: user.notifications.unread.count.to_s }
      end
      redirect_to @question
    else
      flash[:danger] = '答案不可为空'
      redirect_to @question
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:content)
    end
end
