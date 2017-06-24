class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])

    if current_user != @group.user
      render_to root_path, alert: "You have on permit"
    end
  end

  def new
    @group = Group.new
  end

  def update
    @group = Group.find(params[:id])

    if current_user != @group.user
      render_to groups_path, alert: "You have on permission"
    end

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
      redirect_to groups_path
    else
      render :new
  end
end

  def destroy
    @group = Group.find(params[:id])

    if current_user != @group.user
      render_to groups_path, alert: "You have on permission"
    end

    @group.destroy
    flash[:alert] = "delete success!"
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end

end
