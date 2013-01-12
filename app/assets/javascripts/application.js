// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
Platz = {};

Platz.renderPartial = function renderPartial(name, locals){
  var tmpl = $('#' + name + '-tmpl').text();
  return $(ejs.render(tmpl, locals));
}

Platz.humanizeTime = function humanizeTime(timeString) {
  var momentDate = moment(Date.parse(timeString));
  return momentDate.format('MMMM Do YYYY, h:mm:ss a');
}

Platz.buildEventLink = function buildEventLink(entry) {
  var id = entry.id.$t;
  return "/events/1?eid=" + encodeURIComponent(id);
}
Platz.getEid = function getEid(){
  var eid;
  $.each(document.location.search.replace("?", "").split("&"), function(index, value){
    if(value.match(/eid=/)){
      eid = value.split("=")[1];
    }
  });
  if(eid){
    return decodeURIComponent(eid);
  }
}