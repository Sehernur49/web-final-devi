class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet

  # POST /tweets/:tweet_id/comments
  def create
    @comment = @tweet.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("comments_#{@tweet.id}", partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.replace("comment_form_#{@tweet.id}", partial: "comments/form", locals: { tweet: @tweet, comment: Comment.new }),
            turbo_stream.update("comment_count_#{@tweet.id}", partial: "tweets/comment_count", locals: { tweet: @tweet.reload })
          ]
        end
        format.html { redirect_to tweet_path(@tweet), notice: "Yorum eklendi!" }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("comment_form_#{@tweet.id}", partial: "comments/form", locals: { tweet: @tweet, comment: @comment })
        end
        format.html { redirect_to tweet_path(@tweet), alert: "Yorum eklenemedi!" }
      end
    end
  end

  # DELETE /tweets/:tweet_id/comments/:id
  def destroy
    @comment = @tweet.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@comment),
            turbo_stream.update("comment_count_#{@tweet.id}", partial: "tweets/comment_count", locals: { tweet: @tweet.reload })
          ]
        end
        format.html { redirect_to tweet_path(@tweet), notice: "Yorum silindi!" }
      end
    else
      redirect_to tweet_path(@tweet), alert: "Bu işlem için yetkiniz yok!"
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
