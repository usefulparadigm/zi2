class Board < ActiveRecord::Base
	has_many :posts, :order => 'created_at DESC'
	belongs_to :group, :counter_cache => true
	validates_presence_of :title, :name
	validates_uniqueness_of :name, :message => "는 이미 사용중입니다."
end
