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

      const that = this;
      codeMirror.on('changes', instance => {
        const value = instance.getValue();
        that.$postBodyInput.val(value).trigger('change');
      });

      codeMirror.on('paste', (instance, ev) => {
        this.handleEditorPaste(ev, url => {
          instance.replaceSelection(this.urlToMarkdownImage(url));
        });
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

  handleEditorPaste = (ev, onSuccess) => {
    const clipboard = ev.clipboardData
      ? ev.clipboardData
      : ev.originalEvent.clipboardData;
    const files = clipboard.files;
    const file = files.length > 0 ? files[0] : null;
    const isImage = file && !!file.type.match('image');

    if (isImage) {
      uploadImage(file, onSuccess);
    }
  };

  handlePostBodyPreview = html => {
    Prism.highlightAll(this.$postBodyPreview.html(html));
  };

  observeImagePaste() {
    this.$postBodyInput.on('paste', ev =>
      this.handleEditorPaste(ev, url => {
        this.replaceSelection(ev.target, this.urlToMarkdownImage(url));
      })
    );
  }

  observePostBodyInputChange() {
    this.$postBodyInput.on('keyup', e => {
      this.updateWordCount();
      this.updateWordLimit();
      this.textConversion.convert(e.target.value, 'markdown');
    });

    this.$postBodyInput.on('change', e => {
      this.updateWordCount();
      this.updateWordLimit();
      this.textConversion.convert(e.target.value, 'markdown');
    });
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

  replaceSelection(myField, myValue) {
    if (myField.selectionStart || myField.selectionStart == '0') {
      var startPos = myField.selectionStart;
      var endPos = myField.selectionEnd;
      myField.value =
        myField.value.substring(0, startPos) +
        myValue +
        myField.value.substring(endPos, myField.value.length);
    } else {
      myField.value += myValue;
    }
  }

  textConversion() {
    return new TextConversion({
      convertedTextCallback: this.handlePostBodyPreview,
    });
  }
}
