class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
  end

  # POST /posts
  # POST /posts.json
  def create
    if params[:post][:picture_base64].present?
      /data:image\/(.*);base64,/ =~ params[:post][:picture_base64]
      ext = $1
      data = params[:post][:picture_base64].gsub(/data:image\/.*;base64,/, '')
      file = Tempfile.new(["post_picture", ".#{ext}"])
      file.binmode
      file.write(Base64.decode64 data)
      params[:post][:picture] = file
    end

    @post = Post.new(params[:post])

    if @post.save
      redirect_to @post, :notice => 'Post was successfully created.'
    else
      render :action => "new"
    end

    file.close if params[:post][:picture_base64].present?
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url
  end
end
