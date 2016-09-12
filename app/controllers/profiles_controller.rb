class ProfilesController < ApplicationController
before_action :set_user, except: [:my_photos, :subscribes_list, :friends_photos]

  def show
  end

  def subscribe
      if current_user.id == @user.id
        redirect_to profile_path(@user), notice: "Вы не можете подписаться на самого себя"
      else
            	if current_user.subscriptions.exists?(friend_id: @user.id)
            		redirect_to profile_path(@user), notice: "Вы уже подписаны на данного пользователя"

            	else
          	  	@subscription = current_user.subscriptions.build
          	  	@subscription.friend_id = @user.id
          	  	@subscription.save
          	  	if @subscription.save
          	  		redirect_to profile_path(@user), notice: "Вы подписаны на данного пользователя"
          	  	end

            	end
      end
  end

  def unsubscribe
        if current_user.id == @user.id
            redirect_to profile_path(@user), notice: "Вы не можете подписаться на самого себя"
        else
            	if current_user.subscriptions.exists?(friend_id: @user.id)
          	  	@subscription = current_user.subscriptions.find_by_friend_id(@user.id)
          	  	@subscription.destroy
          	  	redirect_to profile_path(@user), notice: "Вы больше не подписаны на данного пользователя"

            	else
            	  	redirect_to profile_path(@user), notice: "Вы не были подписаны на данного пользователя"

          	end
      end
  end


def my_photos
  @photos = current_user.photos.order('created_at DESC')
end

def subscribes_list
  @friends = User.where(id: current_user.subscriptions.pluck(:friend_id))
end

def friends_photos
  @photos = Photo.where(user_id: current_user.subscriptions.pluck(:friend_id)).order('created_at DESC')
end

private

    def set_user
      @user = User.find(params[:id])
    end

end




