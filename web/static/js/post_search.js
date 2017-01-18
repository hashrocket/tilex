import {Socket} from "phoenix"

export default class PostSearch {
  constructor(properties) {
    this.searchForm      = properties.searchForm
    this.searchLink      = properties.searchLink
    this.replaceableHtml = properties.replaceableHtml
    this.socket          = new Socket("/socket")
    this.channel         = this.socket.channel("post:search", {})
  }

  init() {
    this.observeSearchInitiation()
    this.observeSearchSubmit()
    this.observeChannelResponse()
    this.channel.join()
  }

  observeSearchInitiation() {
    this.searchLink.on("click", () => {
      this.socket.connect()
    })
  }

  observeSearchSubmit() {
    this.searchForm.on("submit", e => {
      e.preventDefault();
      let query = e.target.elements.query.value
      this.searchFor(query)
    })
  }

  searchFor(query) {
    this.channel.push("search", {query: query})
  }

  observeChannelResponse() {
    this.channel.on("search", payload => {
      this.replaceableHtml.html(payload.html);
    })
  }
}
