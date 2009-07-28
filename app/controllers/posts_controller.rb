class PostsController < ApplicationController
  caches_page :show
  
  PAGE_SIZE = 5
  
  def index
    @posts = Post.all[0,PAGE_SIZE]
    respond_to do |format|
      format.html
      format.atom
    end
  end
  
  def show
    @post = Post.find(params[:id])
    render :action => 'post_'+@post.id
  end
end