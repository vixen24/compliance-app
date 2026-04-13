import { Controller } from "@hotwired/stimulus"
import "tom-select"

export default class extends Controller {
  static values = {
    placeholder: String,
    maxItems: Number
  }

  connect() {
    this.initTomSelect()
  }

  disconnect() {
    if (this.select) {
      this.select.destroy()
    }
  }

  initTomSelect() {
    this.select = new TomSelect(this.element, {
      plugins: ["remove_button"],
      persist: false,
      create: false,
      maxItems: this.hasMaxItemsValue ? Number(this.maxItemsValue) : null,
      placeholder: this.placeholderValue || "Select options...",
      closeAfterSelect: false
    })
  }
}
