import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tweet-form"
export default class extends Controller {
  static targets = ["content", "counterCircle", "counterText", "counterContainer", "submitButton"]

  connect() {
    this.maxLength = 280
    this.circumference = 2 * Math.PI * 15.5 // r=15.5 from SVG
    this.updateCounter()
  }

  updateCounter() {
    if (!this.hasContentTarget) return

    const length = this.contentTarget.value.length
    const remaining = this.maxLength - length
    const progress = length / this.maxLength

    // Update counter text
    if (this.hasCounterTextTarget) {
      this.counterTextTarget.textContent = `${length}/${this.maxLength}`

      // Color changes based on remaining characters
      if (remaining <= 0) {
        this.counterTextTarget.classList.remove("text-gray-500", "text-yellow-500")
        this.counterTextTarget.classList.add("text-red-500")
      } else if (remaining <= 20) {
        this.counterTextTarget.classList.remove("text-gray-500", "text-red-500")
        this.counterTextTarget.classList.add("text-yellow-500")
      } else {
        this.counterTextTarget.classList.remove("text-yellow-500", "text-red-500")
        this.counterTextTarget.classList.add("text-gray-500")
      }
    }

    // Update circular progress
    if (this.hasCounterCircleTarget) {
      const offset = this.circumference - (progress * this.circumference)
      this.counterCircleTarget.style.strokeDashoffset = offset

      // Color the circle
      if (remaining <= 0) {
        this.counterCircleTarget.style.stroke = "#ef4444"
      } else if (remaining <= 20) {
        this.counterCircleTarget.style.stroke = "#eab308"
      } else {
        this.counterCircleTarget.style.stroke = "#1d9bf0"
      }
    }

    // Disable submit if empty or over limit
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = length === 0 || length > this.maxLength
    }
  }
}
