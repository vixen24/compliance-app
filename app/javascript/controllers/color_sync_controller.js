
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker", "text"]

  connect() {
    this.textTarget.value = this.pickerTarget.value
  }

  pickerChanged() {
    this.textTarget.value = this.pickerTarget.value
  }

  textChanged() {
    this.pickerTarget.value = this.textTarget.value
  }
}
