class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :follow, :unfollow, :followers, :following]

  # GET /users/:id
  def show
    @tweets = @user.tweets.includes(:likes, :comments).recent
    @is_following = current_user.following?(@user) unless current_user == @user
  end

  # GET /users
  def index
    @users = User.where.not(id: current_user.id)
                 .order(followers_count: :desc)
  end

  # POST /users/:id/follow
  def follow
    current_user.follow(@user)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "follow_button_#{@user.id}",
            partial: "users/follow_button",
            locals: { user: @user }
          ),
          turbo_stream.replace(
            "followers_count_#{@user.id}",
            partial: "users/followers_count",
            locals: { user: @user.reload }
          )
        ]
      end
      format.html { redirect_to user_path(@user) }
    end
  end

  # DELETE /users/:id/unfollow
  def unfollow
    current_user.unfollow(@user)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "follow_button_#{@user.id}",
            partial: "users/follow_button",
            locals: { user: @user }
          ),
          turbo_stream.replace(
            "followers_count_#{@user.id}",
            partial: "users/followers_count",
            locals: { user: @user.reload }
          )
        ]
      end
      format.html { redirect_to user_path(@user) }
    end
  end

  # GET /users/:id/followers
  def followers
    @users = @user.followers
    render :follow_list
  end

  # GET /users/:id/following
  def following
    @users = @user.following
    render :follow_list
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
