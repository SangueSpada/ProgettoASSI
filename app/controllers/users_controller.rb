class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    RSpotify.authenticate(Rails.application.credentials[:spotify][:client_id], Rails.application.credentials[:spotify][:client_secret])
    @u = User.where(uid: params[:uid]).first
    @user = RSpotify::User.find(@u.uid)
    @communities = Community.joins(:participations).where(participations: {user_id: @u})
    #puts "le community sono:"+ String(@communities.count())
    @posts = @u.posts.order(created_at: :desc)
    @communities.each do |co|
      #puts co.id
    end
    
  end
  
  def follow
    @user = User.where(uid: params[:uid]).first
    #spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    #spotify_user.follow(RSpotify::User.find(@user.uid))
    current_user.followings << @user
    redirect_back(fallback_location: {action: "show", uid: @user.uid})
  end

  def unfollow
    @user = User.where(uid: params[:uid]).first
    #spotify_user = RSpotify::User.new(request.env['devise.auth'])
    #spotify_user.unfollow(RSpotify::User.find(@user.uid))
    current_user.given_follows.find_by(followed_user_id: @user.id).destroy
    redirect_back(fallback_location: {action: "show", uid: @user.uid})
  end

end
