import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "email", "form" ]

  connect() {
    const regex = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

    $("form input[name='contestant[email]']").on("change", function (event) {

      let changed = false

      if (event.type === "propertychange") {
        changed = event.originalEvent.propertyName == "value"
      } else {
        changed = true
      }

      if (changed && regex.test($("input#contestant_email").val())) {
        $("input.btn.btn-success").attr("disabled", false)
        $("input[name='contestant[email]']").removeClass("is-invalid")
        $("form").addClass("was-validated")
      } else {
        $("input.btn.btn-success").attr("disabled", true)
        $("input[name='contestant[email]']").addClass("is-invalid")
        $("form").removeClass("was-validated")
      }

    })
  }

  ajaxSubmit(event) {
    event.preventDefault()

    const email = this.emailTarget.value

    $.ajax({
      method: "POST",
      url: this.data.get("url"),
      data: {
        contestant: { email }
      },
      contentType: "application/x-www-form-urlencoded; charset=utf-8",
      cache: false,
      dataType: "JSON",
      beforeSend: function() {
        // do something
      }
    })
    .done(function(data) {
      if ( data["redirect_to"] )
        window.location.replace( data["redirect_to"] )
    })
    .fail(function() {
      alert("Something went wrong...");
    })
    .always(function () {
      // always do something
    })
  }

}