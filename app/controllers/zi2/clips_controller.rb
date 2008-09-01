class Zi2::ClipsController < ApplicationController
  def destroy
    @clip = Clip.find(params[:id])
    @clip.destroy
    respond_to do |format|
			format.js do
				render :update do |page|
				  page << "$('#clip_#{@clip.id}').remove();"
				end
			end
    end
    #render :nothing => true
  end

end
