import PostSearch from "./post_search"

$(function(){

  $(document.body).on("click", "#flash p", function(e) {
    e.preventDefault();
    $(this).fadeOut(200);
  });

  $(".site_nav__search, .site_nav__about").on("click", ".site_nav__link", function(e) {
    e.preventDefault();
    $(this).closest('li')
      .toggleClass('site_nav--open')
      .find(":input:visible").eq(0).focus();
  });

  new PostSearch({
    searchForm:      $(".site_nav__search form"),
    searchLink:      $(".site_nav__search"),
    replaceableHtml: $("main")
  }).init()
});
