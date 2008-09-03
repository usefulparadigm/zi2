class Post < ActiveRecord::Base
	belongs_to :user
	has_many :clips, :dependent => :destroy
	has_many :replies, :order => 'created_at'
	has_many :diggs, :dependent => :delete_all
	belongs_to :board, :counter_cache => true

  validates_presence_of :title, :content

 	acts_as_taggable
 
	#acts_as_indexed :fields => [:title, :content]
	#searchable_by :title, :content

	attr_writer :uploaded_attachments


  named_scope :filter, lambda { |user| {:conditions => build_conditions(user) }}

  named_scope :group, lambda { |group_name| {:include => {:board => :group}, :conditions => ['groups.name = ?', group_name.to_s], :order => 'sticky DESC, posts.created_at DESC'} }
  named_scope :board, lambda { |board_name| {:include => {:board => :group}, :conditions => ['boards.name = ?', board_name.to_s], :order => 'sticky DESC, posts.created_at DESC'} }

  def group; board.group end

	# Some Named_scopes
  Board.all(:select => 'id, name').each do |board|
      named_scope board.name.to_sym, :conditions => ['board_id = ?', board.id]
  end
  named_scope :recent, lambda { |*limit| { :limit => (limit.first||5), :order => 'created_at DESC' } }

	def recent?; created_at > 3.days.ago end

	# Virtual attributes for file upload
	def uploaded_attachments=(attachments)
		attachments.each do |attach|
			if attach && attach.size > 0
				attachment = Clip.new
				attachment.uploaded_data = attach
				self.clips << attachment
			end
		end
	end
	
	def new_clips=(clip_ids)
		clip_ids.each do |id|
			clips << Clip.find(id) #.update_attribute(:post_id, self.id)
		end
	end
	
	def digg!(ip, digger = nil)
		unless digged_by? ip, digger
			digg = Digg.new
			digg.user_id = digger.id if digger && !digger.id.nil?
			digg.ip = ip
			diggs << digg
			return true
		else
			return false
		end
	end

	def to_s; title end

private

  def self.build_conditions(user)  
    conditions = "open_level=#{OpenLevel::PUBLIC} "
    if user
      conditions += "OR open_level=#{OpenLevel::MEMBERS_ONLY} "
      conditions += "OR (open_level=#{OpenLevel::FRIENDS_ONLY} AND user_id IN (#{user.me_and_friends.map(&:id).join(',')})) "
      conditions += "OR (open_level=#{OpenLevel::PRIVATE} AND user_id=#{user.id}) "
    end  
    conditions
  end

	def digged_by?(ip, digger = nil)
		if digger && !digger.id.nil?
			return diggs.count(:conditions => ['user_id = ? and ip = ?', digger.id, ip]) > 0
		else
			return diggs.count(:conditions => ['ip = ?', ip]) > 0
		end
	end

end
