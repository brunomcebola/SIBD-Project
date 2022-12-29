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
    <h3>Create %s Reservation</h3>
    <form action="create_trip.cgi" method="post" class="ui form">
      <p>Takeoff: <input type="text" name="takeoff"/></p>
      <p>Arrival: <input type="text" name="arrival"/></p>
      <p>Insurance: <input type="text" name="insurance"/></p>
      <p>From Latitude: <input type="text" name="from_latitude"/></p>
      <p>From Longitude: <input type="text" name="from_longitude"/></p>
      <p>To Latitude: <input type="text" name="to_latitude"/></p>
      <p>To Longitude: <input type="text" name="to_longitude"/></p>
      <p>Skipper: <input type="text" name="skipper"/></p>
      <p>Reservation Start Date: <input type="text" name="reservation_start_date"/></p>
      <p>Reservation End Date: <input type="text" name="reservation_end_date"/></p>
''')

for i in range (2):
  print('''
      <p>Boat %d: <input type="text" name="boat_country"/></p>
  ''' % i)

print('''
      <p>CNI: <input type="text" name="cni"/></p>
      <p><input type="submit" value="Submit"/></p>
    </form>
  </body>
</html>
''')