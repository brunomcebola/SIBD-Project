#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
firstname = form.getvalue('firstname')
surname = form.getvalue('surname')
email = form.getvalue('email')
sailor_type = form.getvalue('sailor_type')

print('Content-type:text/html\n\n')

print("""
<html>
    <head>
        <title>Create Sailor</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <style>
            body, html {
                height: 100%;
            }

            .bg {                
                /* The image used */
                background-image: url("boat_wallpaper_transparent.png");
                background-position: center;
                background-repeat: no-repeat;
                background-attachment: fixed;
                background-size: cover;

                min-height: 100%;
            }
            
            .ui {
                position: fixed;
            }
            
            .material-icons {
                padding-right: 5px;
            }
            
            .content {
                padding: 75px 25px;
            }
            
            table {
                position: relative !important;
                width: 100% !important;
            }
            
            .pagination {
                position: relative;
            }
        </style>
    </head>
    <body>
        <div class="bg">
            <div class="ui five item menu">
                <a class="item" href="home.cgi"><i class="material-icons">home</i>Home</a>
                <a class="item" href="sailors.cgi">Sailors</a>
                <a class="item" href="reservations.cgi" >Reservations</a>
                <a class="item" href="sailors_auth.cgi">Authorised Sailors</a>
                <a class="item" href="trips.cgi">Trips</a>
            </div>
            <div class="content">
""")
connection = None
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql_sailor = 'INSERT INTO sailor VALUES(%s,%s,%s);';  
    data_sailor = (firstname, surname, email)
    
    sql_type = 'INSERT INTO {} VALUES(%s);'.format("senior" if sailor_type == "senior" else "junior")
    data_type = (email, )

    # Feed the data to the SQL query as follows to avoid SQL injection
    cursor.execute("SET CONSTRAINTS ALL DEFERRED;")
    cursor.execute(sql_sailor, data_sailor)
    cursor.execute(sql_type, data_type)

    # Commit the update (without this step the database will not change)
    connection.commit()

    # Closing connection
    cursor.close()
    
    print('<h1>Sailor successfully created</h1>')

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred in the input of the querry. Try again, if there is still an error contact the server</h1>')

finally:
    if connection is not None:
        connection.close()
        
print("""
            </div>
        </div>
    </body>
</html>
""")