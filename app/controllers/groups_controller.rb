class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :update, :destroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy, :join, :quit]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
  end

  def new
    @group = Group.new
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "update success!"
    else
      render :edit
    end
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
  end
end

  def destroy
    @group.destroy
    flash[:alert] = "delete success!"
    redirect_to groups_path
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@gourp)
      current_user.join!(@group)
      flash[:notice] = "Join successfully !"
    else
      flash[:warning] = "You need join the group !"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "Quit successfully !"
    else
      flash[:warning] = "You have quit it !"
    end

    redirect_to group_path(@group)
  end

  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])

    if current_user != @group.user
      render_to group_path, alert: "You have on permission"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end

end
