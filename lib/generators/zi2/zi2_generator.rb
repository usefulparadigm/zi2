class Zi2Generator < Rails::Generator::NamedBase
	def manifest
		record do |m|
			m.class_collisions class_name
			#m.directory('public/stylesheets')
			#m.file('application.css', 'public/stylesheets/application.css')
			m.directory("app/views/#{file_name}")
			m.template('controller_template.rb',
								 "app/controllers/#{file_name}_controller.rb")
		end
	end
end