App.notifications = App.cable.subscriptions.create('NoticesChannel', {
  collection: function() {
    return $("[data-channel='notices']");
  },
  received: function(data) {
    this.collection().css("color", "#FF7F24");
    this.collection().text(data.body);
    // console.log(data.body);
  },
  connected: function() {
    console.log('connected success');
  }
});
