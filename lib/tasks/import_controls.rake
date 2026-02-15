namespace :import do
  desc "Import compliance controls from Excel"
  task controls: :environment do
    require "roo"
    require "pp"

    file_path = "db/seeds/controls.xlsx" # Default path

    begin
      puts "✅ Extracting data from file ..."

      xlsx = Roo::Excelx.new(file_path)
      headers = xlsx.row(1).map(&:strip)

      framework_cache = {}
      control_cache = {}

      ActiveRecord::Base.transaction do
        puts "✅ Loading data into Database ..."

        (2..xlsx.last_row).each do |row_index|
          row = Hash[headers.zip(xlsx.row(row_index))]
          domain     = row["Domain"].to_s.strip
          category   = row["Category"].to_s.strip
          control_number = row["control_id"].to_s.strip
          question   = row["Questions"].to_s.strip

          next if control_number.blank? || question.blank?
          puts "Skipping row #{row_index}: control_id=#{control_number.inspect}, question=#{question.inspect}" if control_number.blank? || question.blank?

          row.each do |header, value|
            next if [ "Domain", "Category", "control_id", "Questions", "Response" ].include?(header)
            next if value.nil?

            value = value.to_s.strip
            next if value.empty?

            framework_cache[header.to_s.strip] ||= Framework.find_or_create_by!(code: header.to_s.strip)
            framework = framework_cache[header.to_s.strip]

            control_cache[control_number] ||= Control.find_or_create_by!(control_id: control_number, question: question) do |c|
              c.domain   = domain
              c.category = category
            end
            control = control_cache[control_number]

            FrameworkControl.where(framework_id: framework.id, control_id: control.id)
                            .first_or_create!(code: value)
          end
        end
      end

      puts "✅ Data imported successfully from #{file_path}"
    rescue => e
      puts "❌ Error: #{e.message}"
      raise ActiveRecord::Rollback
      exit 1
    end
  end
end
