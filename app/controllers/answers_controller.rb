class AnswersController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action only: [:edit, :update, :destroy] do
    @answer = Answer.find params[:id]
    correct_user @answer.user
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))
    if @answer.save
      flash[:success] = '创建答案成功'
      # 向当前问题发布者发送通知
      create_answer_notification(@answer)
      # 向关注者发送公告
      #create_followers_notification @answer
      redirect_to @question
    else
      flash[:danger] = '答案不可为空'
      redirect_to @question
    end
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(answer_params)
      flash[:success] = '答案修改成功'
      redirect_to question_url @answer.question
    else
      render 'edit'
    end
  end

  def destroy
    question = Answer.find(params[:id]).question
    Answer.find(params[:id]).destroy
    flash[:success] = '答案删除成功'
    redirect_to question_url question
  end

  private
  def answer_params
    params.require(:answer).permit(:content)
  end
end
