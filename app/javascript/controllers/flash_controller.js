import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Adiciona um event listener para o botão close
    this.element.querySelector('.btn-close').addEventListener('click', () => {
      this.element.remove()
    })
  }
}