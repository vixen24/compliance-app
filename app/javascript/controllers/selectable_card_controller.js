import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["card"];
  static values = { selectedCardId: Number }

  connect() {
    this.selectInitialCard()
  }

  selectInitialCard() {
    this.cardTargets.forEach((card) => {
      card.classList.toggle("selected", Number(card.dataset.cardId) == this.selectedCardIdValue)
    })
  }

  select(event) {
    this.cardTargets.forEach(card => card.classList.remove("selected"));
    event.currentTarget.classList.add("selected");
  }
}

