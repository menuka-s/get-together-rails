function statusChangeCallback(response) {
  var fbLogin = document.getElementById('facebookLogin'),
    fbLogout = document.getElementById('facebookLogout'),
    greet = document.getElementById('userGreeting'),
    fbStatus = document.getElementById('status');

  if (response.status === 'connected') {
    // Logged into your app and Facebook.
    fbLogin.style.display = 'none';
    fbLogout.style.display = 'inline';
    fbStatus.innerHTML = 'Login successful';
    App.greetUser();
    // Send user data if not logged in already.
    if (localStorage.getItem('app_social_uid') === '') {
      // Send the user data to the server.
      App.sendUserData();
    }
  } else if (response.status === 'not_authorized') {
    // The person is logged into Facebook, but not your app.
    fbStatus.innerHTML = 'Please log into this app.';
    greet.innerHTML = '';
  } else {
    // The person is not logged into Facebook, so we're not sure if
    // they are logged into this app or not.
    fbLogin.style.display = 'inline';
    fbLogout.style.display = 'none';
    greet.innerHTML = '';
    fbStatus.innerHTML = 'Login Using';
  }
}

/**
 * Check status and show the login dialog
 */
function loginUsingFacebook() {
  FB.login(function(response) {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }, {scope: 'public_profile, email'});
}
