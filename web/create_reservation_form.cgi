#!/usr/bin/python3
print('Content-type:text/html\n\n')

print('''
<html>
  <head>
    <title>Reservation</title>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.7/dist/semantic.css" />
    <script src="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.7/dist/semantic.js"></script>
    
  </head>
  <body>
    
    <h3>Create Reervation</h3>
    <form action="create_reservation.cgi" method="post" class="ui form">
        <div class="ui form">
            <div class="fields">
                <div class="field">
                    <div class="ui calendar" id="start_date">
                        <div class="ui input left icon">
                        <i class="calendar icon"></i>
                        <input type="text" placeholder="Start Date" name="start_date">
                        </div>
                    </div>
                </div>
                <div class="field">
                    <div class="ui calendar" id="end_date">
                        <div class="ui input left icon">
                        <i class="calendar icon"></i>
                        <input type="text" placeholder="End Date" name="end_date">
                        </div>
                    </div>
                </div>
            </div>

            <div class="fields">
                <div class="field">
                    <label>Country</label>
                    <input type="text" placeholder="Country" name="country">
                </div>
                <div class="field">
                    <label>CNI</label>
                    <input type="text" placeholder="CNI" name="cni">
                </div>
                <div class="field">
                    <label>Email</label>
                    <input type="text" placeholder="Email" name="email">
                </div>
            </div>
        </div>
      <button class="ui button" type="submit">Submit</button>
    </form>
    <script>
        $('#start_date').calendar();
        $('#end_date').calendar();
    </script>
    <button class="ui primary basic button">
        <a href="home.cgi">Home</a>
    </button>
  </body>
</html>
''')