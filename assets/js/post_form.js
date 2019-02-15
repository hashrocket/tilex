import TextConversion from './text_conversion';
import autosize from 'autosize';
import CodeMirror from 'codemirror';
import 'codemirror-mode-elixir';
import 'codemirror/keymap/vim';
import 'codemirror/mode/gfm/gfm';
import 'codemirror/mode/ruby/ruby';
import 'codemirror/mode/javascript/javascript';
import 'codemirror/mode/go/go';
import 'codemirror/mode/elm/elm';
import 'codemirror/mode/erlang/erlang';
import 'codemirror/mode/css/css';
import 'codemirror/mode/sass/sass';
import 'codemirror/lib/codemirror.css';
import 'codemirror/theme/dracula.css';
import { uploadImage } from './image_uploader.js';

export default class PostForm {
  constructor(props) {
    this.$postBodyInput = props.postBodyInput;
    this.$postBodyPreview = props.postBodyPreview;
    this.$wordCountContainer = props.wordCountContainer;
    this.$bodyWordLimitContainer = props.bodyWordLimitContainer;
    this.bodyWordLimit = props.bodyWordLimit;
    this.$titleInput = props.titleInput;
    this.$titleCharacterLimitContainer = props.titleCharacterLimitContainer;
    this.titleCharacterLimit = props.titleCharacterLimit;
    this.$previewTitleContainer = props.previewTitleContainer;
    this.loadingIndicator = props.loadingIndicator;
    this.textConversion = this.textConversion();
  }

  init() {
    if (!this.$postBodyInput.length) return;

    const { editor } = window.Tilex.clientConfig;
    this.textConversion.init();
    this.setInitialPreview();
    this.observePostBodyInputChange();
    this.observeTitleInputChange();
    this.observeImagePaste();
    autosize(this.$postBodyInput);

    const useCodeMirror = /Code Editor|Vim/.test(editor);

    if (useCodeMirror) {
      const defaultOptions = {
        lineNumbers: true,
        theme: 'dracula',
        tabSize: 2,
        mode: 'gfm',
        insertSoftTab: true,
        smartIndent: false,
        lineWrapping: true,
      };

      const options =
        editor === 'Vim'
          ? { ...defaultOptions, keyMap: 'vim' }
          : defaultOptions;

      const textarea = this.$postBodyInput.get(0);
      const codeMirror = CodeMirror.fromTextArea(textarea, options);

      // const that = this;
      codeMirror.on('changes', instance => {
        const value = instance.getValue();
        this.$postBodyInput.val(value).trigger('change');
      });

      codeMirror.on('paste', (instance, ev) => {
        const handleImageUploadSuccess = url => {
          instance.replaceSelection(this.urlToMarkdownImage(url));
          this.hideLoadingIndicator();
        };

        this.handleEditorPaste(
          ev,
          handleImageUploadSuccess,
          this.handleImageUploadError
        );
      });
    }
  }

  setInitialPreview() {
    this.textConversion.convert(this.$postBodyInput.text(), 'markdown');
    this.updateWordCount();
    this.updateWordLimit();
    this.updateTitleLimit();
    this.updatePreviewTitle();
  }

  wordCount() {
    return this.$postBodyInput
      .val()
      .split(/\s+|\n/)
      .filter(Boolean).length;
  }

  updateWordCount() {
    this.$wordCountContainer.html(this.wordCount());
  }

  updateWordLimit() {
    this.renderCountMessage(
      this.$bodyWordLimitContainer,
      this.bodyWordLimit - this.wordCount(),
      'word'
    );
  }

  updateTitleLimit() {
    this.renderCountMessage(
      this.$titleCharacterLimitContainer,
      this.titleCharacterLimit - this.$titleInput.val().length,
      'character'
    );
  }

  updatePreviewTitle() {
    this.$previewTitleContainer.text(this.$titleInput.val());
  }

  renderCountMessage($el, amount, noun) {
    var plural = amount === 1 ? '' : 's';
    $el
      .toggleClass('negative', amount < 0)
      .text(amount + ' ' + noun + plural + ' available');
  }

  handleEditorPaste = (ev, onSuccess, onError) => {
    const clipboard = ev.clipboardData
      ? ev.clipboardData
      : ev.originalEvent.clipboardData;
    const files = clipboard.files;
    const file = files.length > 0 ? files[0] : null;
    const isImage = file && !!file.type.match('image');

    if (isImage) {
      this.showLoadingIndicator();
      uploadImage(file, onSuccess, onError);
    }
  };

  showLoadingIndicator() {
    this.loadingIndicator.style.display = 'flex';
  }

  hideLoadingIndicator() {
    this.loadingIndicator.style.display = 'none';
  }

  handleImageUploadError = ({ showAlert = true }) => {
    if (showAlert) alert(`Failed to upload image to Imgur`);
    this.hideLoadingIndicator();
  };

  handlePostBodyPreview = html => {
    Prism.highlightAll(this.$postBodyPreview.html(html));
  };

  handlePostBodyChanged = ({ target: { value } }) => {
    this.updateWordCount();
    this.updateWordLimit();
    this.textConversion.convert(value, 'markdown');
  };

  observeImagePaste() {
    this.$postBodyInput.on('paste', ev => {
      const handleImageUploadSuccess = url => {
        this.hideLoadingIndicator();
        this.replaceSelection(ev.target, this.urlToMarkdownImage(url));
        this.handlePostBodyChanged(ev);
      };

      this.handleEditorPaste(
        ev,
        handleImageUploadSuccess,
        this.handleImageUploadError
      );
    });
  }

  observePostBodyInputChange() {
    this.$postBodyInput.on('keyup', this.handlePostBodyChanged);
    this.$postBodyInput.on('change', this.handlePostBodyChanged);
  }

  observeTitleInputChange() {
    this.$titleInput.on('input', e => {
      this.updateTitleLimit();
      this.updatePreviewTitle();
    });
  }

  urlToMarkdownImage(url) {
    return `![image](${url})`;
  }

  replaceSelection(field, myValue) {
    if (field.selectionStart || field.selectionStart == '0') {
      var startPos = field.selectionStart;
      var endPos = field.selectionEnd;
      field.value =
        field.value.substring(0, startPos) +
        myValue +
        field.value.substring(endPos, field.value.length);
    } else {
      field.value += myValue;
    }
  }

  textConversion() {
    return new TextConversion({
      convertedTextCallback: this.handlePostBodyPreview,
    });
  }
}
