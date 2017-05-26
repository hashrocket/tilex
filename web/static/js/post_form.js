import TextConversion from "./text_conversion"

export default class PostForm {
  constructor(properties) {
    this.postBodyInput = properties.postBodyInput
    this.postBodyPreview = properties.postBodyPreview
    this.wordCountContainer = properties.wordCountContainer
    this.handlePostBodyPreview = this.handlePostBodyPreview.bind(this);
    this.textConversion = this.textConversion()
  }

  init() {
    if (!this.postBodyInput.length) { return; }
    this.textConversion.init()
    this.setInitialPreview()
    this.observePostBodyInputChange()
  }

  setInitialPreview() {
    this.textConversion.convert(this.postBodyInput.text(), "markdown");
    this.updateWordCount()
  }

  updateWordCount() {
    let word_count = this.postBodyInput.val().split(/\s+|\n/).filter(Boolean).length;
    this.wordCountContainer.html(word_count);
  }

  handlePostBodyPreview(html) {
    this.postBodyPreview.html(html)
  }

  observePostBodyInputChange() {
    this.postBodyInput.on("input", e => {
      this.updateWordCount()
      this.textConversion.convert(e.target.value, "markdown");
    })
  }

  textConversion() {
    return new TextConversion({
      convertedTextCallback: this.handlePostBodyPreview,
    })
  }
}
