class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, only: %i(show edit update destroy)

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      flash[:danger] = t ".signup_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".pro_updated"
      redirect_to @user
    else
      flash[:danger] = t ".pro_not_updated"
      render :edit
    end
  end

  def index
    @users = User.select_user.page(params[:page])
      .per(Settings.controller.per_page).order("name DESC")
    end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_del"
    else
      flash[:danger] = t ".user_del_fail"
    end
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
    end

    def logged_in_user
      return if logged_in?
      store_location
      flash[:danger] = t ".pls"
      redirect_to login_url
    end

    def correct_user
      @user = User.find_by params[:id]
      unless @user == current_user(@user)
       redirect_to root_url
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def find_user
      @user = User.find_by params[:id]
      return if @user
      flash[:danger] = t ".not_found"
      redirect_to users_url
    end
end
