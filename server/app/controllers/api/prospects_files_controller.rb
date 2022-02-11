class Api::ProspectsFilesController < ApplicationController
  def import
    prospects_file = ProspectsFile.new({
      **prospects_file_params,
      user_id: @user.id,
    })
    prospects_file.save!

    # Create an asynchronously Job to insert into prospects
    ProspectsFilesImportJob.perform_later(prospects_file.id)

    render json: {id: prospects_file.id, message: "Your file was uploaded. Use the '/api/prospects_files/:id/progress' to get the insert progress."}

  rescue ActiveRecord::RecordInvalid => e
    # Validation error
    return render status: 400, json: {message: e.record.errors}
  end

  def progress
    prospects_file = ProspectsFile.find_by(id: params.require(:id))

    if prospects_file.nil?
      return render status: 404, json: {message: "The prospect file does not exist."}
    end

    if prospects_file.user_id != @user.id
      return render status: 403, json: {message: "The prospect file does not belong to this user."}
    end

    render json: {total: prospects_file.total, done: prospects_file.done}
  end

  private
    def prospects_file_params
	    params.permit(:csv_file, :file_path, :email_index, :first_name_index, :last_name_index, :force, :has_headers)
    end
end
