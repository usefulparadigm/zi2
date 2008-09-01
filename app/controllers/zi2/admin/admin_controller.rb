class Zi2::Admin::AdminController < ApplicationController
	layout 'zi2/admin'
	before_filter :check_administrator_role
end