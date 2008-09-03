module Zi2Helper

  def display_tree_recursive(tree, parent_id)
    ret = "\n<ul id=\"category\">"
    tree.each do |node|
      if node.parent_id == parent_id
        ret += "\n\t<li>"
        ret += yield node
        ret += display_tree_recursive(tree, node.id) { |n| yield n } unless node.children.empty?
        ret += "\t</li>\n"
      end
    end
    ret += "</ul>\n"
  end

	def display_breadcrumbs(categories)
		categories.collect { |category| yield category }.join(' > ')
	end

	def expand_tree_into_select_field(categories, current_id = nil)
	  returning(String.new) do |html|
	    categories.each do |category|
	      html << %{<option value="#{ category.id }">#{ '&nbsp;&nbsp;&nbsp;' * category.ancestors.size }#{ category.name }</option>}
	      html << expand_tree_into_select_field(category.children) if category.has_children?
	    end
	  end
	end

	def javascript_onload(function=nil)
		# generated javascript function sample: mycontrollers.initAction();
		function ||= "#{controller.controller_name}.init#{controller.action_name.capitalize}"
		#function = function.to_s
		content_for(:javascript) do
			%Q(window.onload = #{function.to_s};)
		end
	end
	
	def include_stylesheet(*sources)
		content_for(:stylesheet) do
			stylesheet_link_tag(*sources)
		end
	end
	
	def include_javascript(*sources)
		content_for(:javascript) do
			javascript_include_tag(*sources)
		end
	end
	
	def jquery_onload(&block)
		content_for(:jquery_onload) do
			javascript_tag "$(document).ready(function() { #{capture(&block)} });"
		end
	end
  
	def page_title(title)
		content_tag :h2, title, :class => 'title'
	end
	
	def span_tag(value)
		content_tag :span, value
	end
	
	def button_link_to(name, options = {}, html_options = {})
		link_to(span_tag(name), options, html_options.merge(:class => 'button'))
	end
	
	#def button_submit_tag(value, options={})
	#	span_tag(submit_tag(value, options), :class => 'button')
	#end

	def menu_current(name)
		unless @group_name.blank?
			(@group_name == name) ? 'current' : nil
		else
			(controller.controller_name == name) ? 'current' : nil
		end
	end
	
	def current_board_if(name, board_name = controller.action_name)
	  "current" if name == board_name
	end
	
	def list_view?
		(controller.action_name == 'list') || !@board
	end
	
	def render_zi2_list
		render :partial => 'list'
	end
	def render_posts_index
		render :partial => 'index'
	end
		
	def created_date(post)
	  post.created_at.year == Time.now.year ? post.created_at.to_s(:kmd) : post.created_at.to_s(:kymd)
  end	
  
  def empty_msg(collection, tag=:li, msg='항목이 없습니다.')
    content_tag tag, :class => 'empty' do 
      msg
    end if collection.empty?
  end
end
