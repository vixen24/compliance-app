namespace :uba_2025_import do
  desc "Import compliance controls from Excel"
  task liberia_answers: :environment do
    require "roo"
    require "pp"

    file_path = "db/seeds/uba_2025_data/UBA_liberia_2025_workpaper.xlsx"

    puts "✅ Extracting data from file ..."

    xlsx = Roo::Excelx.new(file_path)
    headers = xlsx.row(1).map(&:strip)

    # ChANGE SUBSIDIARY HERE
    assessment = Assessment.find_by(team_id: 14)
    raise "Assessment not found for team_id" unless assessment.id

    controls = AssessmentControl
               .where(assessment_id: assessment.id)
               .index_by(&:control_id)

    answers = []

    ActiveRecord::Base.transaction do
      puts "✅ Loading Mozambique data into Database ..."

      (2..xlsx.last_row).each do |row_index|
        row = Hash[headers.zip(xlsx.row(row_index))]

        control_number = row["control_id"]
        response  = row["Response"].to_s.strip
        response = "NA" if response == "N/A"

        raise "Missing response at row #{i}" if response.blank?

        control = controls[control_number]
        raise "Missing control mapping for #{control_number}, total number of controls #{controls.count}" unless control

        answers << {
          assessment_id: assessment.id,
          assessment_control_id: control.id,
          status: response,
          state: "approved",
          user_id: 2
        }
      end

      Answer.insert_all!(answers)
    end

    puts "✅ Data imported successfully from #{file_path}"
  rescue => e
    puts "❌ Error: #{e.message}"
    raise
  end
end
