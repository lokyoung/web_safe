class Admin::ExperimentsController < Admin::AdminController
  def index
    @experiments = Experiment.page params[:page]
  end

  def edit
    @experiment = Experiment.find params[:id]
  end

  def update
    @experiment = Experiment.find params[:id]
    if @experiment.update_attributes experiment_params
      stuclass_ids = params[:experiment][:stuclass_ids]
      @experiment.stuclass_ids = stuclass_ids

      flash[:success] = '作业资料修改成功'
      redirect_to admin_experiments_url
    else
      render 'edit'
    end
  end

  def destroy
    experiment = Experiment.find(params[:id])
    file_delete experiment.experimentfile
    experiment.destroy
    flash[:success] = '作业删除成功'
    redirect_to admin_experiments_url
  end

  private

  def experiment_params
    params.require(:experiment).permit(:title, :description, :experimentfile)
  end

end
