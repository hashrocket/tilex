$(function(){


  var csrf = document.querySelector("meta[name=csrf]").content;

  function LikeButton(el) {
    this.id = el.id;
    this.$el = $(el);
    this.$count = this.$el.find('.post__like-count')
    this.$el.on("click", $.proxy(this.toggle, this));
    this.updateClass();
  };

  LikeButton.prototype.toggle = function(e) {
    e.preventDefault();
    this.isLiked() ? this.unlike() : this.like();
  };

  LikeButton.prototype.like = function() {
    var lb = this;
    $.ajax({
      type: "POST",
      url: "/posts/" + lb.id + "/like.json",
      data: {},
      success: function(result) {
        $.cookie(lb.likeSlug(), 'liked', { path: '/', expires: 3600 });
        lb.updateText(result);
        lb.updateClass();
      },
      headers: {
        "X-CSRF-TOKEN": csrf
      }
    });
  };

  LikeButton.prototype.unlike = function() {
    var lb = this;
    $.ajax({
      type: "POST",
      url: "/posts/" + lb.id + "/unlike.json",
      data: {},
      success: function(result){
      $.removeCookie(lb.likeSlug(), { path: '/', expires: 3600 });
      lb.updateText(result);
      lb.updateClass();
      },
      headers: {
        "X-CSRF-TOKEN": csrf
      }
    });
  };

  LikeButton.prototype.updateClass = function() {
    this.$el.toggleClass('liked', this.isLiked());
  }

  LikeButton.prototype.updateText = function(result) {
    this.$count.text(result.likes);
  };

  LikeButton.prototype.isLiked = function() {
    return !!$.cookie(this.likeSlug());
  };

  LikeButton.prototype.likeSlug = function() {
    return 'liked -' + this.id;
  };

  $('.js-like-action').each(function() {
    new LikeButton(this);
  });

  $('header').attr('data-likes-loaded', 'true')
});
