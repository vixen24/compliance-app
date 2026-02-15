import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { key: String }

  connect() {
    if (!this.hasKeyValue) return

    const saved = localStorage.getItem(this.storageKey())
    if (saved === "open") {
      this.element.open = true
    }

    this.toggleHandler = () => {
      localStorage.setItem(
        this.storageKey(),
        this.element.open ? "open" : "closed"
      )
    }

    this.element.addEventListener("toggle", this.toggleHandler)
  }

  disconnect() {
    if (this.toggleHandler) {
      this.element.removeEventListener("toggle", this.toggleHandler)
    }
  }

  storageKey() {
    return `details:${this.keyValue}`
  }
}

