import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Campaign Controller")
  }

  ajaxResendConfirmation(event) {
    event.preventDefault()

    const { secretCode } = event.target.dataset

    console.log(this.data.get("url"))

    $.ajax({
      method: "POST",
      url: this.data.get("url"),
      contentType: "application/x-www-form-urlencoded; charset=utf-8",
      cache: false,
      dataType: "JSON",
      beforeSend: function() {
        // do something
      }
    })
    .done(function(data) {
      console.log(">>>", data["message"])
    })
    .fail(function() {
      alert("Something went wrong...")
    })
    .always(function () {
      // always do something
    })
  }

}
