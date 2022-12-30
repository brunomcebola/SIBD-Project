#!/usr/bin/python3
import psycopg2
import login

print('Content-type:text/html; charset=utf-8\n\n')

print('''
<!DOCTYPE html>
<html>
  <head>
    <title>Trip</title>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.7/dist/semantic.css" />
    <script src="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.7/dist/semantic.js"></script>
  </head>
  <body>
    <h3>Create Trip</h3>
    <style>
      #parent {
          display: flex;
          justify-content: space-between;
      }

      
      #right {
        width: 70%;
      }
    </style>

    <div id="parent">

        <div id="left">
          <form action="create_trip.cgi" method="post" class="ui form">
            <div class="ui form">

              <div class="fields">
                <div class="field">
                    <label>Takeoff</label>
                    <input type="text" placeholder="Takeoff" name="takeoff">
                </div>
                <div class="field">
                    <label>Arrival</label>
                    <input type="text" placeholder="Arrival" name="arrival">
                </div>
              </div>

              <div class="fields">
                <div class="field">
                    <label>Insurance</label>
                    <input type="text" placeholder="Insurance" name="insurance">
                </div>
              </div>

              <div class="fields">
                <div class="field">
                    <label>From Latitude</label>
                    <input type="text" placeholder="From Latitude" name="from_latitude">
                </div>
                <div class="field">
                    <label>From Longitude</label>
                    <input type="text" placeholder="From Longitude" name="from_longitude">
                </div>
              </div>

              <div class="fields">
                <div class="field">
                    <label>To Latitude</label>
                    <input type="text" placeholder="To Latitude" name="to_latitude">
                </div>
                <div class="field">
                    <label>To Longitude</label>
                    <input type="text" placeholder="To Longitude" name="to_longitude">
                </div>
              </div>

              <div class="fields">
                <div class="field">
                    <label>Skipper</label>
                    <input type="text" placeholder="Skipper" name="skipper">
                </div>
              </div>

              <div class="fields">
                <div class="field">
                    <label>Reservation Start Date</label>
                    <input type="text" placeholder="Reservation Start Date" name="reservation_start_date">
                </div>
                <div class="field">
                    <label>Reservation End Date</label>
                    <input type="text" placeholder="Reservation End Date" name="reservation_end_date">
                </div>
              </div>
              
              <div class="fields">
                <div class="field">
                    <label>Country</label>
                    <input type="text" placeholder="Country" name="boat_country">
                </div>
                <div class="field">
                    <label>CNI</label>
                    <input type="text" placeholder="CNI" name="cni">
                </div>
              </div>
            </div>

            <button class="ui button" type="submit">Submit</button>
          </form>
        </div>
''')
print("""
        <div id="right">
          <h3> Available Locations </h3>
""")

connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT * FROM location;'
    cursor.execute(sql)
    result = cursor.fetchall()

    num = len(result)

    # Displaying results
    print("""
        <table class="ui celled table">
            <thead>
                <tr><th>Latitude</th>
                <th>Longitude</th>
                <th>Name</th>
                <th>Country Name</th>
            </tr></thead>
            <tbody> 
    """)
    for row in result:
        print('<tr>')
        for value in row:
            # The string has the {}, the variables inside format() will replace the {}
            print('<td>{}</td>'.format(value))
        # Remove Reservation
        print('</tr>')
    print('</table>')
    # Closing connection
    cursor.close()
except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred.</h1>') 
    print('<p>{}</p>'.format(e))
finally:
    if connection is not None:
        connection.close()


print("""
      </div>
    </div>
    <button class="ui primary basic button">
        <a href="home.cgi">Home</a>
    </button>
  </body>
</html>
""")