$(document).ready(function(){
  window.addEventListener('message', function(event) {

      if (event.data.action == 'cinema') {
        $("#top").slideDown(500);
        $("#bottom").slideDown(500);
      } else {
        $('#top').slideUp(200);
        $('#bottom').slideUp(200);
      };

  });
});
