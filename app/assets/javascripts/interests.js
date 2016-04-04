  $(document).ready(function(){
    var userActivities = $("#user-activities").text();
    var activitiesArray = userActivities.split(',');
    $("#activity").keyup(function(){
      $("#suggestions-container").empty();
      var userInput = $("#activity").val();
      var searchString = new RegExp(userInput, "gi");
      if($("#suggestions-container").css("display")=="none"){
        $("#suggestions-container").slideToggle("slow");
        console.log($("#activity").val())
      }
      activitiesArray.forEach(function(activity){

        if (activity.match(searchString) != null){
          $("#suggestions-container").append("<div class = 'activity-suggestion'>" + activity + "</div>")
        }
      })
    });
    $("#suggestions-container").on("click", ".activity-suggestion", function(){
      $("#suggestions-container").slideToggle("slow");
    });

  });
