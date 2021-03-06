var myService;
var feedUrl = "https://www.google.com/calendar/feeds/2d59pfgvh7109cp3k9g167d3f4%40group.calendar.google.com/private-d6169d6bb928f792dc55386b7646d788/full";

function setupMyService() {
  myService = new google.gdata.calendar.CalendarService('exampleCo-exampleApp-1');
}

function handleMyFeed(data){
  var feedData = data;
  var eid = Platz.getEid();
  if(eid){
    var entry;
    $.each(feedData.feed.entry, function(index, value){
      if(value.id.$t == eid){
        entry = value;
      }
    });

    var html = Platz.renderPartial("event", {event: entry});
    $("#container").html(html);

    var disqus_shortname = 'eventagon'; // required: replace example with your forum shortname
    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'https://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
  } else{
    var html = Platz.renderPartial("event-list", {entries: data.feed.entry});
    $("#events").html(html);
  }
}
function handleError(){
}
function getMyFeed() {
  setupMyService();
  myService.getEventsFeed(feedUrl, handleMyFeed, handleError);
}

google.load("gdata", "1");
google.setOnLoadCallback(getMyFeed);
