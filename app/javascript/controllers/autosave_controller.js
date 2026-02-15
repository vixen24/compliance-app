import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  debouncedSubmit = this.debounce(() => this.submit(), 500)

  submit() {
    if (!this.element) return
    this.element.requestSubmit()
  }

  debounce(callback, ms) {
    let timeout
    return (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => callback(...args), ms)
    }
  }
}

