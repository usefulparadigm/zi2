class Clip < ActiveRecord::Base
	belongs_to :post, :counter_cache => true
	has_attachment :storage => :file_system, 
								 #:processor => 'RMagick', 
								 :resize_to => '700x',
                 :thumbnails => { :thumb => [70, 70] },
								 :max_size => 2.megabytes
	validates_as_attachment
end
