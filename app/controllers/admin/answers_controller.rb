class Admin::AnswersController < Admin::AdminController
  def index
    @question = Question.find params[:question_id]
    @answers = @question.answers.page params[:page]
  end

  def edit
    @question = Question.find params[:question_id]
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(answer_params)
      flash[:success] = '话题修改成功'
      redirect_to admin_question_answers_url
    else
      render 'edit'
    end
  end

  def destroy
    Answer.find(params[:id]).destroy
    flash[:success] = '话题删除成功'
    redirect_to admin_question_answers_url
  end

  def show_comments
    @answer = Answer.find(params[:id])
    @comments = @answer.comments.page params[:page]
    render 'admin/comments/show_comments'
  end

  private
  def answer_params
    params.require(:answer).permit(:content)
  end
end
