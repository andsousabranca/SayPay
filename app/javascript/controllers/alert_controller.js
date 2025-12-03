import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {

  initSweetalert(event) {
    Swal.fire({
      title: "Drag me!",
      icon: "success",
      draggable: true
    });
  }
}
