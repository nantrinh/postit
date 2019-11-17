class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.all.sort_by {|post| post.created_at}
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    @post.creator = User.find_by username: 'Test' 

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

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
