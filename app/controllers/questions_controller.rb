class QuestionsController < ApplicationController
  before_action :logged_in_user

  def index
    # 根据分页显示问题
    @questions = Question.page params[:page]
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:success] = '发布问题成功'
      redirect_to questions_url
    else
      render 'new'
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def destroy
    Question.find(params[:id]).destroy
    flash[:success] = '问题删除成功'
    redirect_to questions_url
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(update_params)
      flash[:success] = '修改成功'
      redirect_to @question
    else
      render 'edit'
    end
  end

  private
    def question_params
      params.require(:question).permit(:title, :content)
    end

    def update_params
      params.require(:question).permit(:title, :content, :issolved)
    end
end
