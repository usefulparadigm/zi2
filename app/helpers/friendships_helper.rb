module FriendshipsHelper
	def user_link(user)
		link_to image_tag(user.avatar.url(:thumb)), user_path(user)
	end
end
