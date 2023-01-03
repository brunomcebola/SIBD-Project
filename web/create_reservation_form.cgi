#!/usr/bin/python3
import psycopg2
import login
print('Content-type:text/html; charset=utf-8\n\n')

print("""
<html>
  <head>
    <title>Reservation</title>
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
    <h3>Create Reservation</h3>
    <form action="create_reservation.cgi" method="post" class="ui form">
        <div class="ui form">
            <div class="fields">
                <div class="field">
                    <div class="ui calendar" id="start_date">
                        <div class="ui input left icon">
                        <i class="calendar icon"></i>
                        <input type="date" placeholder="Start Date" name="start_date">
                        </div>
                    </div>
                </div>
                <div class="field">
                    <div class="ui calendar" id="end_date">
                        <div class="ui input left icon">
                        <i class="calendar icon"></i>
                        <input type="date" placeholder="End Date" name="end_date">
                        </div>
                    </div>
                </div>
            </div>

            <div class="fields">
                <div class="field">
                    <select name="country">
                        <option value="">Country</option> 
                        """)
connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT name FROM country;'
    cursor.execute(sql)
    result = cursor.fetchall()

    num = len(result)

    for row in result:
        for value in row:
            print('<option value="{}">{}</option>'.format(row[0], row[0]))
    # Closing connection
    print(""" 
                    </select>
                </div>
                <div class="field">
                    <select name="cni">
                        <option value="">CNI</option> 
    """)
    sql = 'SELECT cni FROM boat;'
    cursor.execute(sql)
    result = cursor.fetchall()

    num = len(result)

    for row in result:
        for value in row:
            print('<option value="{}">{}</option>'.format(row[0], row[0]))
    print(""" 
                    </select>
                </div>
                <div class="field">
                    <select name="email">
                        <option value="">Email</option> 
    """)
    sql = 'SELECT email FROM sailor;'
    cursor.execute(sql)
    result = cursor.fetchall()

    num = len(result)

    for row in result:
        for value in row:
            print('<option value="{}">{}</option>'.format(row[0], row[0]))

    print(""" 
                    </select>
                </div>
            </div>
    """)

    cursor.close()
except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred in the input of the querry. Try again, if there is still an error contact the server</h1>')
finally:
    if connection is not None:
        connection.close()
                        
print("""
        </div>
      <button class="ui button" type="submit">Submit</button>
    </form>
    <button class="ui yellow button">
        <a href="sailors.cgi">Home</a>
    </button>
    </div>
  </body>
</html>
""")