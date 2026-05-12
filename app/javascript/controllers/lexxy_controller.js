import { Controller } from "@hotwired/stimulus";


export default class extends Controller {
  connect() {
    this.editor = this.element.querySelector("lexxy-editor");

    if (this.editor?.hasAttribute("readonly")) {
      this.setReadonlyState();
    }
    this.disableAttachments();
  }

  setReadonlyState() {
    this.removeToolbar();
    this.changeContentEditable();
  }

  removeToolbar() {
    const toolbar = this.element.querySelector("lexxy-toolbar");
    if (toolbar) toolbar.remove();
  }

  changeContentEditable() {
    const contenteditable = this.element.querySelector('[contenteditable="true"]');
    if (contenteditable) {
      contenteditable.setAttribute("contenteditable", "false");
    }
  }

  disableAttachments() {
    const toolbar = this.element.querySelector("lexxy-toolbar");

    if (toolbar) {
      toolbar.setAttribute("data-attachments", "false");
    }
  }
}
