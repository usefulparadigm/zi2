class Group < ActiveRecord::Base
	has_many :boards
	validates_presence_of :title, :name
	validates_uniqueness_of :name, :message => "는 이미 사용중입니다."

	def self.options
		self.find(:all).collect {|g| [ g.title, g.id ] }
	end
	
end
