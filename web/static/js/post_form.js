import TextConversion from "./text_conversion"

export default class PostForm {
  constructor(properties) {
    this.postBodyInput = properties.postBodyInput
    this.postBodyPreview = properties.postBodyPreview
    this.wordCountContainer = properties.wordCountContainer
    this.bodyWordLimitContainer = properties.bodyWordLimitContainer
    this.bodyWordLimit = properties.bodyWordLimit
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
    this.updateWordLimit()
  }

  wordCount() {
    return this.postBodyInput.val().split(/\s+|\n/).filter(Boolean).length;
  }

  updateWordCount() {
    this.wordCountContainer.html(this.wordCount());
  }

  updateWordLimit() {
    this.renderCountMessage(
      this.bodyWordLimitContainer,
      this.bodyWordLimit - this.wordCount(),
      'word'
    );
  }

  renderCountMessage($el, amount, noun) {
    var plural = amount === 1 ? '' : 's';
    $el
      .toggleClass('negative', amount < 0)
      .text(amount + ' ' + noun + plural + ' available');
  }

  handlePostBodyPreview(html) {
    this.postBodyPreview.html(html)
  }

  observePostBodyInputChange() {
    this.postBodyInput.on("input", e => {
      this.updateWordCount();
      this.updateWordLimit();
      this.textConversion.convert(e.target.value, "markdown");
    })
  }

  textConversion() {
    return new TextConversion({
      convertedTextCallback: this.handlePostBodyPreview,
    })
  }
}
