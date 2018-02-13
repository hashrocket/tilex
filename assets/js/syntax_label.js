$(function() {
  $.fn.syntaxLabel = function() {
    var $el = $(this);
    var $hl = $el.filter('pre code').add($el.find('pre code'));

    $hl.each(function() {
      var language = $(this)
        .attr('class')
        .replace(/\s*hljs\s*/, ' ')
        .trim()
        .split(' ')[0];
      $(this).parent().attr('data-language', language);
      $(this).attr('class', language + ' ' + 'hljs');
    });
  };
});
