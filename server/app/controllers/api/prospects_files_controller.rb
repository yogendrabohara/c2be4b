class Api::ProspectsFilesController < ApplicationController
  def import
    prospects_file = ProspectsFile.new({
      **prospects_file_params,
      user_id: @user.id,
    })
	
    result = ""
    if prospects_file.save
      ProspectsFilesImportJob.perform_later(prospects_file.id)
      result = "success"
    else
      result = "failed"
    end

    render json: {"result": result, "data": ""}
  end

  private
    def prospects_file_params
	    params.permit(:csv_file, :file_path, :email_index, :first_name_index, :last_name_index, :force, :has_headers)
    end
end
