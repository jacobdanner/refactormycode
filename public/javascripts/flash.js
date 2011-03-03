var Flash = {
  data: {},

  transferFromCookies: function() {
    var data = JSON.parse(unescape(Cookie.get("flash")));
    if(!data) data = {};
    Flash.data = data;
    Cookie.erase("flash");
  },

  writeDataTo: function(name, element) {
    element = $(element);
    var content = "";
    if(Flash.data[name]) {
      content = Flash.data[name].toString().gsub(/\+/, ' ');
      element.show();
    } else {
      return;
    }
    element.innerHTML = unescape(content);
  },

  dropOut: function(element, sleep) {
    element = $(element);
    element.style.width = element.up().getWidth() - 49 + 'px';
    setTimeout(function() { new Effect.DropOut(element) }, sleep || 3000);
  }
};
