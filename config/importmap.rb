pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/helpers", under: "helpers"
pin_all_from "app/javascript/turbo/stream_actions", under: "turbo/stream_actions"
pin "turbo/stream_actions", to: "turbo/stream_actions.js"
# pin_all_from "app/javascript/turbo/stream_actions", under: "turbo/stream_actions"
pin "plotly_theme", to: "lib/plotly_theme.js"
pin "plotly.js-basic-dist" # @3.4.0
pin "process" # @2.1.0
pin "tom-select"
