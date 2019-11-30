class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:show, :index]
  before_action :require_creator_or_admin, only: [:edit, :update] 

  def index
    @posts = Post.all.sort_by {|post| post.created_at}
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = 'Your post was created.'
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'This post was updated.'
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    # there should be at most 1 element in the array because we enforce
    # uniqueness of user-voteable
    existing_votes = @post.votes.where(user_id: current_user.id)
    if existing_votes.empty?
      Vote.create(voteable: @post, creator: current_user, vote: params[:vote])
    else
      existing_votes.first.update(vote: params[:vote])
    end

    @upvote = params[:vote]

    respond_to do |format|
      format.html do
        redirect_back fallback_location: root_path
      end
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find_by slug: params[:id]
  end

  def require_creator_or_admin
    access_denied unless logged_in? && (current_user == @post.creator || current_user.admin?)
  end
end
