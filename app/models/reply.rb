class Reply < ActiveRecord::Base
	belongs_to :user
	belongs_to :post, :counter_cache => true
  validates_presence_of :author, :unless => :has_logged_in_user?

	named_scope :public_only, :conditions => ['secret = ?', false]

	def has_logged_in_user?
		!self.user.nil?
	end
end
