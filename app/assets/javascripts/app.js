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

        var selectedActivity = $("#activity").val();
        $("#selected-activity").text(selectedActivity);
        $("#activity-input").val(selectedActivity);
        $("#activity").val("");
        $("#activity").toggle();
        $("#activity-cancel").toggle();

        $("#new-activity-category-container").removeClass("hidden");
        $("#suggestions-container").hide();

        // What about when someone clicks away?? or wants to select something else? -- User question.

      });



      $(document).on("click", function(){
        if($("#suggestions-container").css("display")!="none"){
          $("#suggestions-container").hide();
        }
      });


    $("#activity-container").on("click", "#activity-cancel", function(){
        $("#activity-cancel").toggle();
        $("#selected-activity").text("");
         $("#activity").toggle();
         $("#new-activity-category-container").addClass("hidden");
         $("input:checkbox").removeAttr("checked");
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
        $(".event-comments").append(comment);
        $("#comment_content").val("");
      })}
    });

    $("#user-bio").on("click", function(){
      if ($("#bio-textarea").css("display") == "none" ){
        $("#user-bio-header").toggle();
        $("#user-bio-content").toggle();
        $("#bio-textarea").toggle();
        $("#bio-button").toggle();
      }
    });
    $("#bio-button").on("click", function(){

      var textContent = $("#bio-update-field").val();
      var patchUrl = $(".menu a:eq(1)").attr("href")
      $.ajax({
        method: "PATCH",
        url: patchUrl,
        data: {bio: textContent}
      })
      .done(function(response){
        console.log(response)
        $("#user-bio-header").toggle();
        $("#user-bio-content").text(response.bio);
        $("#user-bio-content").toggle();
        $("#bio-textarea").toggle();
        $("#bio-button").toggle();
      });
    });

  });
