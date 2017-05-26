import TextConversion from "./text_conversion"

export default class PostForm {
  constructor(properties) {
    this.postBodyInput = properties.postBodyInput
    this.postBodyPreview = properties.postBodyPreview
    this.handlePostBodyPreview = this.handlePostBodyPreview.bind(this);
    this.textConversion = this.textConversion()
  }

  init() {
    this.textConversion.init()
    this.setInitialPreview()
    this.observePostBodyInputChange()
  }

  setInitialPreview() {
    this.textConversion.convert(this.postBodyInput.text(), "markdown");
  }

  handlePostBodyPreview(html) {
    this.postBodyPreview.html(html)
  }

  observePostBodyInputChange() {
    this.postBodyInput.on("input", e => {
      this.textConversion.convert(e.target.value, "markdown");
    })
  }

  textConversion() {
    return new TextConversion({
      convertedTextCallback: this.handlePostBodyPreview,
    })
  }
}
