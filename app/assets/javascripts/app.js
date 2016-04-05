  $(document).ready(function(){
    if ($("#activity-input").val() != ""){
      $("#activity").toggle();
      $("#activity-cancel").toggle();
      $("#selected-activity").text($("#activity-input").val());
    };
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
        var activityMatches = 0;
        activitiesArray.forEach(function(activity){

          if (activity.match(searchString) != null){
            activityMatches+=1
            $("#suggestions-container").append("<div class = 'activity-suggestion'>" + activity + "</div>")
          }
        })
        if (activityMatches == 0) {
          $("#suggestions-container").append("<div id = 'new-activity'>No matches...Create new?</div>")
        }
      });
      $("#suggestions-container").on("click", ".activity-suggestion", function(){
        $("#activity").val("");
        $("#activity").toggle();
        $("#activity-cancel").toggle();
        var selectedActivity = $(this).text();
        $("#selected-activity").text(selectedActivity);
        $("#activity-input").val(selectedActivity);
        $("#suggestions-container").slideToggle("slow");
        $("#suggestions-container").hide();
      });
      $("#suggestions-container").on("click", "#new-activity", function(){
        window.location.assign("/activities/new")
      });

      // $(document).on("click", function(){
      //   if($("#suggestions-container").css("display")!="none"){
      //     $("#suggestions-container").slideToggle("slow");
      //   }
      // });


    $("#activity-container").on("click", "#activity-cancel", function(){
        $("#activity-cancel").toggle();
        $("#selected-activity").text("");
         $("#activity").toggle();
        });
    $("#comment-button").on("click", function(){
      if ($("#comment_content").val()!=""){
      var commentText = $("#comment_content").val();
      var eventId = $("#event-id").text();
      $.ajax({
        method: "POST",
        url: "/events/"+ eventId + "/comments",
        data: {content: commentText}
      })
      .done(function(comment){
        $("#comment-container").append(comment);
        $("#comment_content").val("");
        // console.log(comment);
      })}
    });
  });
