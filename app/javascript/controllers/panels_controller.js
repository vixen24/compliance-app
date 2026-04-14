// NB: Used in admin/setting for layout
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    this.buttons = this.element.querySelectorAll("button[data-panel-target]")
  }

  switch(event) {
    const targetPanel = event.currentTarget.dataset.panelTarget
    const panels = this.element.querySelectorAll(".panel-content")

    panels.forEach(panel => {
      if (panel.dataset.panel === targetPanel) {
        panel.classList.remove("hidden")
      } else {
        panel.classList.add("hidden")
      }
    })

    this.buttons.forEach(btn => {
      if (btn.dataset.panelTarget === targetPanel) {
        btn.classList.add("font-semibold", "bg-neutral-800", "text-white")
      } else {
        btn.classList.remove("font-semibold", "bg-neutral-800", "text-white")
      }
    })
  }
}
