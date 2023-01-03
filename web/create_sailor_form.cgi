#!/usr/bin/python3
print('Content-type:text/html\n\n')

print('''
<html>
  <head>
    <title>Sailor</title>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.7/dist/semantic.css" />
    <script src="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.7/dist/semantic.js"></script>
    <style>
        body, html {
        height: 100%;
        }

        .bg {
        /* The image used */
        background-image: url("boat_wallpaper.jpg");

        /* Full height */
        height: 100%;

        /* Center and scale the image nicely */
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;

        padding: 50px;
        }
    </style>
  </head>
  <body>
    <div class="bg">
      <h2>Create Sailor</h2>
      <form action="create_sailor.cgi" method="post" class="ui form">
          <div class="ui form">
              <div class="fields">
                  <div class="field">
                      <label>Firstname</label>
                      <input type="text" placeholder="First Name" name="firstname">
                  </div>
                  <div class="field">
                      <label>Surname</label>
                      <input type="text" placeholder="Middle Name" name="surname">
                  </div>
                  <div class="field">
                      <label>Email</label>
                      <input type="text" placeholder="Email" name="email">
                  </div>
                  <div class="field">
                      <label>Senior/Junior</label>
                      <input type="text" placeholder="Senior/Junior" name="sailor_type">
                  </div>
              </div>
          </div>
        <button class="ui button" type="submit">Submit</button>
      </form>
      <button class="ui yellow button">
          <a href="sailors.cgi">Home</a>
      </button>
    </div>
  </body>
</html>
''')