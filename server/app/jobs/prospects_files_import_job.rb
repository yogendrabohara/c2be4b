require 'csv'

class ProspectsFilesImportJob < ApplicationJob
  queue_as :default

  def perform(prospects_files_import_job_id)
    prospects_file = ProspectsFile.find(prospects_files_import_job_id)
    tmp_file_path = Rails.root.join('tmp', 'csv_file.csv')

    # Write to tmp file
    file_content = prospects_file.csv_file.download
    File.open(tmp_file_path, 'wb') do |file|
      file.write(file_content)
    end

    # Insert to User
    ActiveRecord::Base.transaction do
      CSV.foreach(tmp_file_path, encoding: 'CP932:UTF-8') do |line|
        Prospect.create!(user_id: prospects_file.user_id, email: line[0], first_name: line[1], last_name: line[2])
      end
    end

    # Remove tmp file
    ensure
      File.delete(tmp_file_path) if File.exist?(tmp_file_path)
  end
end
