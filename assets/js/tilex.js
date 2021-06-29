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

      // Close all OTHER links to prevent overlap
      const site_nav_links = document.getElementsByClassName('site_nav__link')
      for (let i = 0; i < site_nav_links.length; i++) {
        if ($(this).parent()[0] != $(site_nav_links[i]).parent()[0]) {
          $(site_nav_links[i]).closest('li').removeClass('site_nav--open')
        }
      }

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
