import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $(".add-image-file").on("change", function (e) {

      let file = $(this).find("input.image-file-input")[0].files[0];

      let fd = new FormData();
          fd.append('data', file)

      upload(fd)

    });

    const upload = (data) => {
      $.ajax({
        url: '/images',
        data: data,
        processData: false,
        type: 'POST',
        contentType: false,
        cache: false,
        mimeType: 'multipart/form-data',
        dataType: 'JSON',
        beforeSend: function() {
          console.log(">>> Uploading...")
        }
      })
      .done(function (data) {
        $("div.d-flex.flex-wrap").prepend(data['image_file_html'])
      })
      .always(function () {
        console.log(">>> always")
      })
    }
  }

  removeImage(event) {
    event.preventDefault()

    const id = event.target.dataset.id

    $.ajax({
      method: "DELETE",
      url: `/images/${id}`
    })
    .done(function( msg ) {
      $(`.image-file-${id}`).remove();
    });
  }
}
