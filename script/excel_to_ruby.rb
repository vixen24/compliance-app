require "roo"
require "pp"

xlsx = Roo::Excelx.new("script/controls.xlsx")

headers = xlsx.row(1).map(&:strip)

controls = []

(2..xlsx.last_row).each do |row_index|
  row = Hash[headers.zip(xlsx.row(row_index))]

  control = {
    domain:     row["Domain"],
    category:   row["Category"],
    control_id: row["control_id"],
    question:   row["Questions"],
    response:   row["Response"],
    mappings: {}
  }

  row.each do |key, value|
    next if [ "Domain", "Category", "control_id", "Questions", "Response" ].include?(key)
    next if value.nil? || value.to_s.strip.empty?

    control[:mappings][key] =
      value.to_s.split(",").map(&:strip)
  end

  controls << control
end

File.open("config/compliance_controls.rb", "w") do |f|
  f.puts "COMPLIANCE_CONTROLS ="
  f.puts controls.pretty_inspect
end

puts "✅ compliance_controls.rb generated"
