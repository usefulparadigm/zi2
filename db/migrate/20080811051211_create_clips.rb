class CreateClips < ActiveRecord::Migration
  def self.up
    create_table :clips do |t|

	    t.column 	:size,					:integer  # file size in bytes
	    t.column 	:content_type, 	:string   # mime type, ex: application/mp3
	    t.column 	:filename,			:string   # sanitized filename
	    t.column 	:height,				:integer  # in pixels
    	t.column 	:width, 				:integer  # in pixels
    	t.column 	:parent_id,			:integer  # id of parent image
			t.column 	:thumbnail,			:string   # the 'type' of thumbnail this attachment record describes.  
			
			t.column :post_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :clips
  end
end
