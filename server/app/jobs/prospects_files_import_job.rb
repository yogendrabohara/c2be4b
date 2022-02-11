require "csv"

class ProspectsFilesImportJob < ApplicationJob
  queue_as :default

  def perform(prospects_files_import_job_id)
    prospects_file = ProspectsFile.find(prospects_files_import_job_id)
    prospects_file.csv_file.open do |file|
      total = file.count()
      row_number = 1
      CSV.foreach(file, encoding: "CP932:UTF-8") do |line|
        # Insert to User
        insert(row_number, line, prospects_file)
        # Update progress to ProspectsFile
        update_progress(total, row_number, prospects_file)

        row_number += 1
      end
    end
  end

  private
    # Insert csv data into prospects table
    def insert(row_number, line, prospects_file)
        if row_number == 1 and prospects_file.has_headers
          # Skip if the file has headers
          return
        end

        email = line[prospects_file.email_index - 1]
        if email == nil
          # Skip if email is none
          return
        end

        first_name = ""
        if prospects_file.first_name_index
          first_name = line[prospects_file.first_name_index - 1]
        end

        last_name = ""
        if prospects_file.last_name_index
          last_name = line[prospects_file.last_name_index - 1]
        end

        prospects = Prospect.where(user_id: prospects_file.user_id, email: email) 
        if prospects.count() == 0
          # Save if the data is new
          Prospect.create!(
            user_id: prospects_file.user_id,
            email: email,
            first_name: first_name,
            last_name: last_name
          )
        elsif prospects_file.force
          # Overwrite if force is true
          for prospect in prospects
            prospect.first_name = first_name
            prospect.last_name = last_name
            prospect.save!()
          end
        end
    end

    # Update progress
    def update_progress(total, row_number, prospects_file)
      prospects_file.total = total
      prospects_file.done = row_number
      prospects_file.save!()
    end
end
