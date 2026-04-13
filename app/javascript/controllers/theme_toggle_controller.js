import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["light", "system", "business"]

  connect() {
    const theme = localStorage.getItem("theme") || "system"
    this[`${theme}Target`].classList.add("theme-selected")
  }

  select(event) {
    const selected = event.currentTarget.dataset.themeToggleTarget
    localStorage.setItem("theme", selected)
    this.applyTheme(selected)
    this.selectButton(selected)
    window.dispatchEvent(new CustomEvent("theme:changed", { detail: { selected } }))
  }

  applyTheme(selected) {
    const theme = selected === "system" ? this.systemTheme() : selected
    document.documentElement.setAttribute("data-theme", theme)
  }

  systemTheme() {
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "business" : "light"
  }

  selectButton(name) {
    this.lightTarget.classList.remove("theme-selected")
    this.systemTarget.classList.remove("theme-selected")
    this.businessTarget.classList.remove("theme-selected")

    this[`${name}Target`].classList.add("theme-selected")
  }


}
