class Admin::AnnouncesController < Admin::AdminController
  def index
    @announces = Announce.page params[:page]
  end

  def edit
    @announce = Announce.find(params[:id])
  end

  def update
    @announce = Announce.find(params[:id])
    if @announce.update_attributes(announce_params)
      flash[:success] = '公告修改成功'
      redirect_to admin_announces_url
    else
      render 'edit'
    end
  end

  def destroy
    Announce.find(params[:id]).destroy
    flash[:success] = '公告删除成功'
    redirect_to admin_announces_url
  end

  private
  def announce_params
    params.require(:announce).permit(:title, :content)
  end
end
