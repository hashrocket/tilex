import PostForm from './post_form';

$(function() {
  $('#flash p').on(
    'load',
    (function() {
      setTimeout(function() {
        $('#flash p').fadeOut(200);
      }, 10000);
    })()
  );

  $(document.body).on('click', '#flash p', function(e) {
    e.preventDefault();
    $(this).fadeOut(200);
  });

  $('.site_nav__search, .site_nav__about').on(
    'click',
    '.site_nav__link',
    function(e) {
      e.preventDefault();
      $(this)
        .closest('li')
        .toggleClass('site_nav--open')
        .find(':input:visible')
        .eq(0)
        .focus();
    }
  );

  new PostForm({
    postBodyInput: $('textarea#post_body'),
    postBodyPreview: $('.content_preview'),
    wordCountContainer: $('.word_count'),
    bodyWordLimitContainer: $('.word_limit'),
    bodyWordLimit: $('.word_limit').data('limit'),
    titleInput: $('input#post_title'),
    titleCharacterLimitContainer: $('.character_limit'),
    titleCharacterLimit: $('.character_limit').data('limit'),
    previewTitleContainer: $('.title_preview'),
    loadingIndicator: document.querySelector('.loading-indicator'),
  }).init();
});
