class PostsController < ApplicationController
  caches_page :show
  
  PAGE_SIZE = 5
  
  def index
    params[:page] ||= 0
    @posts = Post.all[params[:page] * PAGE_SIZE,PAGE_SIZE]
    respond_to do |format|
      format.html
      format.atom
    end
  end
  
  def show
    @post = Post.find(params[:id])
  end
end