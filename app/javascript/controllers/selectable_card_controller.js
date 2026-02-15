import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["card"];

  connect() {
    // Select second card on connect
    this.selectCard(this.cardTargets[0]);
  }

  select(event) {
    // Called by click -> pass event
    this.selectCard(event.currentTarget);
  }

  selectCard(card) {
    // Remove 'selected' class from all cards
    this.cardTargets.forEach(c => c.classList.remove("selected"));

    // Add 'selected' class to the chosen card
    card.classList.add("selected");

    // Store the selected card ID
    this.selectedCardId = card.dataset.cardId;
    // console.log("Selected card ID:", this.selectedCardId);
  }
}
