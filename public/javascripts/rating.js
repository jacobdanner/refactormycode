var Rating = Class.create();
Rating.prototype = {
  initialize: function(element, rating, options) {
    this.element = $(element);
    this.rating  = rating;
    this.maxRating = 5;
    this.options = options || {};
    
    this.bindedOnHover = this.onHover.bindAsEventListener(this);
    this.bindedOnExit  = this.onExit.bindAsEventListener(this);
    this.bindedOnClick  = this.onClick.bindAsEventListener(this);
    
    Event.observe(this.element, 'mouseover', this.bindedOnHover);
    Event.observe(this.element, 'mouseout', this.bindedOnExit);
    Event.observe(this.element, 'click', this.bindedOnClick);
    
    this.instanciateStars();
    this.showStarts(this.rating);
  },
  
  instanciateStars: function() {
    this.maxRating.times(function() {
      var img = document.createElement('img');
      this.element.appendChild(img);
    }.bind(this));
  },
  
  showStarts: function(number) {
    var stars = this.getStars();

    $R(0, number-1).each (function(position) {
      stars[position].src = '/images/star_full.png';
    });
    $R(number, this.maxRating-1).each (function(position) {
      stars[position].src = '/images/star_empty.png';
    });
  },
  
  getStars: function() {
    return this.element.getElementsBySelector('img');
  },
  
  onHover: function(event) {
    var element = Event.element(event);
    if (element.tagName == 'IMG') {
      this.showStarts(this.findRatingFromEvent(element));
    }
  },
  
  onExit: function(event) {
    this.showStarts(this.rating);
  },
  
  onClick: function(event) {
    var element = Event.element(event);
    if (element.tagName == 'IMG' && this.options.onClick) {
      this.options.onClick.bind(this)(this.findRatingFromEvent(element));
    }
  },
  
  findRatingFromEvent: function(element) {
    var r = 0;
    this.getStars().each(function(star) {
      r ++;
      if (star == element) {
        throw $break;
      }
    });
    return r;
  },
  
  disable: function() {
    Event.stopObserving(this.element, 'mouseover', this.bindedOnHover);
    Event.stopObserving(this.element, 'mouseout', this.bindedOnExit);
    Event.stopObserving(this.element, 'click', this.bindedOnClick);
  }
};