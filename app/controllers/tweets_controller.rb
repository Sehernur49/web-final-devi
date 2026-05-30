class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :authorize_tweet!, only: [:edit, :update, :destroy]

  # GET /tweets (Ana sayfa - Feed)
  def index
    @tweet = Tweet.new
    @filter = params[:filter] || "all"
    
    if @filter == "following"
      @tweets = current_user.following_tweets.recent.limit(50)
    else
      @tweets = current_user.feed.limit(50)
    end
    
    @trending_users = User.order(followers_count: :desc).limit(5)
  end
  
  # GET /tweets/search
  def search
    @query = params[:q]
    @tweets = Tweet.where("content LIKE ?", "%#{@query}%").with_associations.recent.limit(20)
    @users = User.where("username LIKE ? OR display_name LIKE ?", "%#{@query}%", "%#{@query}%").limit(10)
    
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /tweets/:id
  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user).recent
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/:id/edit
  def edit
  end

  # POST /tweets
  def create
    @tweet = current_user.tweets.build(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("tweets", partial: "tweets/tweet", locals: { tweet: @tweet }),
            turbo_stream.replace("tweet_form", partial: "tweets/form", locals: { tweet: Tweet.new }),
            turbo_stream.update("tweet_count", current_user.tweets.count.to_s)
          ]
        end
        format.html { redirect_to root_path, notice: "Tweet gönderildi!" }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("tweet_form", partial: "tweets/form", locals: { tweet: @tweet })
        end
        format.html do
          @tweets = current_user.feed.limit(50)
          @trending_users = User.order(followers_count: :desc).limit(5)
          render :index, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /tweets/:id
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@tweet, partial: "tweets/tweet", locals: { tweet: @tweet })
        end
        format.html { redirect_to @tweet, notice: "Tweet güncellendi!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/:id
  def destroy
    @tweet.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@tweet)
      end
      format.html { redirect_to root_path, notice: "Tweet silindi!" }
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:content)
  end

  def authorize_tweet!
    redirect_to root_path, alert: "Bu işlem için yetkiniz yok!" unless @tweet.user == current_user
  end
end
