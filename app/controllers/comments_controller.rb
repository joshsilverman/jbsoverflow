class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(:controller => "posts", :action => "show", :id => @comment.post_id, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(:controller => "posts", :action => "show", :id => @comment.post_id, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(:controller => "posts", :action => "show", :id => @comment.post_id, :notice => 'Comment deleted.') }
      format.xml  { head :ok }
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    current_user.vote_exclusively_for(@comment)
    redirect_to(@comment.post, :notice => 'Successfully voted.')
  end

  def voted
    @post = Comment.find(params[:id]).post
    @vote = Vote.where("voter_id = ? AND voteable_id = ? AND voteable_type = 'Comment'", current_user.id, params[:id]).first
    if @vote
      @vote.destroy
      redirect_to(@post, :notice => 'Successfully unvoted.')
    else
      redirect_to(@post, :notice => 'Can only unvote, not vote against.')
    end
  end
end
