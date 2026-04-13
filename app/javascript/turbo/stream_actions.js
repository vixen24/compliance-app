import { Turbo } from "@hotwired/turbo-rails"

Turbo.StreamActions.redirect = function () {
  const url = this.getAttribute("target") || "/"
  Turbo.visit(url)
}

Turbo.StreamActions.close_dialog = function () {
  const dialog = document.querySelector("dialog[open]")

  if (dialog) {
    dialog.close()
  }
}