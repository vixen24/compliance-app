namespace :imports do
  desc "Run all import answer tasks sequentially"
  task run_all: :environment do
    tasks = [
      "import:chad_answers",
      "import:benin_answers",
      "import:burkinafaso_answers",
      "import:cameroon_answers",
      "import:congobr_answers",
      "import:congodr_answers",
      "import:gabon_answers",
      "import:guinea_answers",
      "import:ivorycoast_answers",
      "import:kenya_answers",
      "import:liberia_answers",
      "import:mali_answers",
      "import:mozambique_answers",
      "import:senegal_answers",
      "import:sierraleone_answers",
      "import:tanzania_answers",
      "import:uganda_answers",
      "import:zambia_answers"
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
