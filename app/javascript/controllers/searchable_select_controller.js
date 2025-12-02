import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="searchable-select"
export default class extends Controller {
  static targets = ["hiddenField", "search", "list"]

  connect() {
    this.options = Array.from(this.listTarget.children)
  }

  toggleList() {
    this.listTarget.classList.toggle("hidden")
  }

  filter() {
    const query = this.searchTarget.value.toLowerCase()

    this.options.forEach( opt => {
      const text = opt.textContent.toLowerCase()
      const value = opt.dataset.value.toLowerCase()

      const match = value.includes(query) || text.includes(query)
      opt.classList.toggle("hidden", !match)
    })

    this.listTarget.classList.remove("hidden")
  }

  select(event) {
    const value = event.currentTarget.dataset.value

    // set hidden field
    this.hiddenFieldTarget.value = value

    // set visible input for the user
    this.searchTarget.value = value

    // close dropdown
    this.listTarget.classList.add("hidden")
  }
}
