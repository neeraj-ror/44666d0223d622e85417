class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    byebug
      if params[:id].present?
        @users = User.where(
          "first_name ILIKE ? or last_name ILIKE ? or email ILIKE ?",
          "%#{params[:id]}%", "%#{params[:id]}%", "%#{params[:id]}%").distinct
      else
        @users = User.all
      end

    render json: @users
  end

  # GET /users/1
  def show
    unless @user.nil?
      render json: @user
    else
      render :action => :index, :id => params[:id]
    end  
    
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where(id: params[:id]).last
    end 

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
end
