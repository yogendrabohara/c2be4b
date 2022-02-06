class Api::ProspectsFilesController < ApplicationController
  def import
	post_params = prospects_file_params
	
	# Save the file into Rails Active Storage


    render json: {"result": post_params}
  end

  private
    def prospects_file_params
	  params.permit(:file, :email_index, :first_name_index, :last_name_index, :force, :has_headers)
    end
end
