'use strict';


require('./index.html');
var Elm = require('./Main');

var elm = Elm.Main.fullscreen();


elm.ports.initializeJquery.subscribe(function(settings) {
  console.log("Initialize js style");
  console.log(settings);
  requestAnimationFrame ( function () {
    $("#datepicker").datepicker({
      dateFormat: settings.dateFormat || "dd.mm.yy",
      onSelect: function(selectedDate) {
        // Send date to Elm when new date is picked
        elm.ports.newDate.send(selectedDate);
      }
    });
  });

});
