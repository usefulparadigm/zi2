xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
	xml.channel do
		xml.title 			@group.title
		xml.link				g_path(@group)
		xml.pubDate			CGI.rfc1123_date @posts.first.created_at if @posts.any?
		xml.description @group.description

		@posts.each do |post|
			xml.item do
				xml.title				post.title
				xml.link				gbp_path(post)
				xml.description	post.content
				xml.pubDate			CGI.rfc1123_date post.created_at
				xml.guid				gbp_path(post)
				xml.author			"#{post.user.email} (#{post.user.login})"
			end
		end
	end
end