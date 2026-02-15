// app/javascript/controllers/multi_select_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "input", "selectedItemsContainer", "options", "hiddenInput"]

  connect() {
    this.selectedItems = new Set()
  }

  toggleDropdown() {
    this.dropdownTarget.classList.toggle("hidden")
  }

  selectItem(event) {
    const item = event.target
    const value = item.dataset.value
    const text = item.textContent.trim()

    if (this.selectedItems.has(value)) {
      this.selectedItems.delete(value)
      item.classList.remove("bg-gray-200")
    } else {
      this.selectedItems.add(value)
      item.classList.add("bg-gray-200")
    }

    this.updateSelectedItems()
  }

  updateSelectedItems() {
    this.hiddenInputTarget.value = Array.from(this.selectedItems).join(",")
    this.selectedItemsContainerTarget.innerHTML = Array.from(this.selectedItems)
      .map(id => `<span class="inline-block px-2 py-1 m-1 bg-blue-100 rounded">${document.querySelector(`[data-value="${id}"]`).textContent}</span>`)
      .join("")
  }

  filterOptions(event) {
    const searchTerm = event.target.value.toLowerCase()
    this.optionsTarget.querySelectorAll("li").forEach(option => {
      const text = option.textContent.toLowerCase()
      option.style.display = text.includes(searchTerm) ? "block" : "none"
    })
  }
}

