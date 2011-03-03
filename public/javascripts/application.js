var CurrentUser = {
  loggedIn: false,
  author: false,
  admin: false,
  
  init: function() {
    this.loggedIn = Cookie.get('token') != null;
    this.admin    = Cookie.get('admin') != null;
  }  
};

var Application = {
  init: function() {
    CurrentUser.init();
  },
  
  onBodyLoaded: function() {
    if (CurrentUser.loggedIn) {
      $$('.if_logged_in').invoke('show');
      $$('.unless_logged_in').invoke('hide');
    }
    if (CurrentUser.admin) {
      $$('.if_admin').invoke('show');
    }
    if (CurrentUser.author) {
      $$('.author_only').invoke('show');
    }
  }
};

var DateHelper = {
  // Source: http://nullstyle.com/2007/6/3/caching-time_ago_in_words
  timeAgoInWords: function(from) {
   return this.distanceOfTimeInWords(new Date().getTime(), from);
  },

  distanceOfTimeInWords: function(to, from) {
    seconds_ago = ((to  - from) / 1000);
    minutes_ago = Math.floor(seconds_ago / 60);

    if(minutes_ago == 0) { return "less than a minute"; }
    if(minutes_ago == 1) { return "a minute"; }
    if(minutes_ago < 45) { return minutes_ago + " minutes"; }
    if(minutes_ago < 90) { return " about 1 hour"; }
    hours_ago  = Math.round(minutes_ago / 60);
    if(minutes_ago < 1440) { return "about " + hours_ago + " hours"; }
    if(minutes_ago < 2880) { return "1 day"; }
    days_ago  = Math.round(minutes_ago / 1440);
    if(minutes_ago < 43200) { return days_ago + " days"; }
    if(minutes_ago < 86400) { return "about 1 month"; }
    months_ago  = Math.round(minutes_ago / 43200);
    if(minutes_ago < 525960) { return months_ago + " months"; }
    if(minutes_ago < 1051920) { return "about 1 year"; }
    years_ago  = Math.round(minutes_ago / 525960);
    return "over " + years_ago + " years";
  }
}

var EffectWatcher = {
  whenComplete: function(callback) {
    this.interval = setInterval(function() {
      if (Effect.Queue.size() > 0) return;
      callback.call();
      this.stop();
    }.bind(this), 40);
  },
  
  stop: function() {
    clearInterval(this.interval);
  }
};