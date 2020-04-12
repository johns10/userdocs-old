// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let Hooks = {}
Hooks.drag_drop_zone = {
  mounted() {
    this.el.addEventListener("drop", e => {
      console.log("Dropping")
      e.preventDefault();
      console.log(e.target.id)
      this.pushEvent("step::reorder_end", { "step-id": e.target.id })
    })
    this.el.addEventListener("dragenter", e => {
      e.dataTransfer.dropEffect = 'move'
      e.preventDefault();
      this.pushEvent("step::reorder_dragenter", { "step-id": e.target.id })
    })
    this.el.addEventListener("dragover", e => {
      e.dataTransfer.dropEffect = 'move'
      e.preventDefault();
      //this.pushEvent("step::reorder_end")
    })
    this.el.addEventListener("dragstart", e => {
      console.log("Moving")
      e.dataTransfer.dropEffect = "move";
      var payload = {
        "source-id": e.target.id,
        "source-type": e.srcElement.attributes.type.value,
        "parent-type": e.srcElement.attributes["parent-type"].value,
        "parent-id": e.srcElement.attributes["parent-id"].value,
        "step-id": e.target.id
      }
      this.pushEvent("step::reorder_start", payload)
    })
  }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks})

liveSocket.connect()

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

