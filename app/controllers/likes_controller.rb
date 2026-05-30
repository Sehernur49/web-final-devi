class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet

  # POST /tweets/:tweet_id/like
  def create
    @like = @tweet.likes.build(user: current_user)

    respond_to do |format|
      if @like.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "like_button_#{@tweet.id}",
            partial: "likes/button",
            locals: { tweet: @tweet.reload }
          )
        end
        format.html { redirect_to root_path }
      else
        format.html { redirect_to root_path, alert: "Beğenilemedi!" }
      end
    end
  end

  # DELETE /tweets/:tweet_id/like
  def destroy
    @like = @tweet.likes.find_by(user: current_user)
    @like&.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "like_button_#{@tweet.id}",
          partial: "likes/button",
          locals: { tweet: @tweet.reload }
        )
      end
      format.html { redirect_to root_path }
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end
end
