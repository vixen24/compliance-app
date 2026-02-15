import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "form", "input"]

  edit() {
    this.displayTarget.classList.add("hidden")
    this.inputTarget.classList.remove("hidden")
    this.inputTarget.focus()
  }

  save() {
    // allow normal form submission
    this.formTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }
}
