namespace :uba_2025_import do
  desc "Run all import answer tasks sequentially"
  task run_all: :environment do
    tasks = [
      "uba_2025_import:chad_answers",
      "uba_2025_import:benin_answers",
      "uba_2025_import:burkinafaso_answers",
      "uba_2025_import:cameroon_answers",
      "uba_2025_import:congobr_answers",
      "uba_2025_import:congodr_answers",
      "uba_2025_import:gabon_answers",
      "uba_2025_import:ghana_answers",
      "uba_2025_import:guinea_answers",
      "uba_2025_import:ivorycoast_answers",
      "uba_2025_import:kenya_answers",
      "uba_2025_import:liberia_answers",
      "uba_2025_import:mali_answers",
      "uba_2025_import:mozambique_answers",
      "uba_2025_import:nigeria_answers",
      "uba_2025_import:senegal_answers",
      "uba_2025_import:sierraleone_answers",
      "uba_2025_import:tanzania_answers",
      "uba_2025_import:uganda_answers",
      "uba_2025_import:zambia_answers"
    ]

    tasks.each do |task_name|
      puts "Running #{task_name}..."

      Rake::Task[task_name].reenable
      Rake::Task[task_name].invoke

      puts "#{task_name} completed"
    end

    puts "All imports completed successfully"
  end
end
