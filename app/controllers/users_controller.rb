class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @schedule = @user.get_schedule
  end

  def new
    if signed_in?
      redirect_to(root_path)
    else
      @user = User.new
      @title = "Sign up"
    end
  end

  def create
    if signed_in?
      redirect_to(root_path)
    else    
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to Trains, #{@user.name}"
        redirect_to @user
      else
        @title = "Sign up"
        render 'new'
      end
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def destroy
    unless User.find(params[:id]).admin?
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
    else
      flash[:error] = "Admin cannot delete himself"
    end
    redirect_to users_path
  end

  private
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
