class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => ["index", "show", "update"]
  uses_tiny_mce :options => {
          :dialog_type => "modal",
          :theme => 'advanced',
          :theme_advanced_resizing => true,
          :theme_advanced_resize_horizontal => false,
          :plugins => %w{ table fullscreen }
        }

  def index
    @posts = Post.all
    @sponsored_ids = []
    if current_user
      sponsored = current_user.posts
      @sponsored_ids = []
      for s in sponsored do
        @sponsored_ids << s.id
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def show
    @post = Post.find(params[:id])
    if current_user
      @is_sponsored = !Sponsorship.where("user_id = ? AND post_id = ?", current_user.id, @post.id).first.nil?
    else
      @is_sponsored = false
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to(@post, :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end

  def vote
    @post = Post.find(params[:id])
    if current_user.vote_count(:all) < 20
      current_user.vote_exclusively_for(@post)
      redirect_to(@post, :notice => 'Successfully voted.')
    else
      redirect_to(@post, :notice => 'You\'ve already voted 10 times.')
    end
  end

  def voted
    @vote = Vote.where("voter_id = ? AND voteable_id = ? AND voteable_type = 'Post'", current_user.id, params[:id]).first
    if @vote
      @vote.destroy
      redirect_to("", :notice => 'Successfully unvoted.')
    else
      redirect_to("", :notice => 'Can only unvote, not vote against.')
    end
  end

  def sponsor
    @post = Post.find(params[:id])

    if @post.users.count >= 5
      redirect_to(@post, :notice => 'Already 5 sponsors.')
    elsif current_user.posts.count >= 3
      redirect_to(@post, :notice => 'You are already sponsoring 3 ideas.')
    else
      current_user.posts << @post
      redirect_to(@post, :notice => 'You are now a sponsor!')
    end
  end

  def unsponsor
    @post = Post.find(params[:id])
    @sponsorship = Sponsorship.where("user_id = ? AND post_id = ?", current_user.id, @post.id).first
    @sponsorship.destroy if @sponsorship
    redirect_to("/", :notice => 'You are no longer a sponsor!')
  end
end
