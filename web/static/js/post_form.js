import TextConversion from "./text_conversion"

export default class PostForm {
  constructor(properties) {
    this.postBodyInput = properties.postBodyInput
    this.postBodyPreview = properties.postBodyPreview
    this.wordCountContainer = properties.wordCountContainer
    this.bodyWordLimitContainer = properties.bodyWordLimitContainer
    this.bodyWordLimit = properties.bodyWordLimit
    this.titleInput = properties.titleInput
    this.titleCharacterLimitContainer = properties.titleCharacterLimitContainer
    this.titleCharacterLimit = properties.titleCharacterLimit
    this.handlePostBodyPreview = this.handlePostBodyPreview.bind(this);
    this.textConversion = this.textConversion()
  }

  init() {
    if (!this.postBodyInput.length) { return; }
    this.textConversion.init()
    this.setInitialPreview()
    this.observePostBodyInputChange()
    this.observeTitleInputChange()
  }

  setInitialPreview() {
    this.textConversion.convert(this.postBodyInput.text(), "markdown");
    this.updateWordCount()
    this.updateWordLimit()
    this.updateTitleLimit()
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

  updateTitleLimit() {
    this.renderCountMessage(
      this.titleCharacterLimitContainer,
      this.titleCharacterLimit - this.titleInput.val().length,
      'character'
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

  observeTitleInputChange() {
    this.titleInput.on("input", e => {
      this.updateTitleLimit();
    })
  }

  textConversion() {
    return new TextConversion({
      convertedTextCallback: this.handlePostBodyPreview,
    })
  }
}
