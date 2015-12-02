class Admin::QuestionsController < Admin::AdminController
  def index
    @questions= Question.page params[:page]
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(question_params)
      flash[:success] = '话题修改成功'
      redirect_to admin_questions_url
    else
      render 'edit'
    end
  end

  def destroy
    Question.find(params[:id]).destroy
    flash[:success] = '话题删除成功'
    redirect_to admin_questions_url
  end

  private
  def question_params
    params.require(:question).permit(:title, :content, :issolved)
  end

end
