import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "eye", "eyeOff"]

  toggle() {
    console.log("Toggling password visibility")
    const isHidden = this.inputTarget.type === "password"

    // Toggle password visibility
    this.inputTarget.type = isHidden ? "text" : "password"

    // Toggle icons
    this.eyeTarget.classList.toggle("hidden")
    this.eyeOffTarget.classList.toggle("hidden")
  }
}
