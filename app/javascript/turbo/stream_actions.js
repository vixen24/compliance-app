import { Turbo } from "@hotwired/turbo-rails"

// Sample use case: 
// format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, teams_path) }
Turbo.StreamActions.redirect = function () {
  const url = this.getAttribute("target") || "/"
  Turbo.visit(url)
}

Turbo.StreamActions.close_dialog = function () {
  const dialog = document.querySelector("dialog[open]")
  const dialog_turbo_frame = document.querySelector(".dialog-turbo-frame")
  if (dialog) dialog.close()
  if (dialog_turbo_frame) dialog_turbo_frame.reload()
}