#!/usr/bin/python3
import psycopg2, cgi
import login
form = cgi.FieldStorage()
#getvalue uses the names from the form in previous page
start_date = form.getvalue('start_date')
end_date = form.getvalue('end_date')
country = form.getvalue('country')
cni = form.getvalue('cni')
email = form.getvalue('email')

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<title>Authenticate Sailor</title>')
print("""<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />""")
print('</head>')
print('<body>')
connection = None
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql_reservation = 'INSERT INTO authorised VALUES(%s,%s,%s,%s,%s);'
    data_reservation = (start_date, end_date,country, cni, email)

    #print('<p>{}</p>'.format(sql_date_interval % data_date_interval))
    print('<p>{}</p>'.format(sql_reservation % data_reservation))

    # Feed the data to the SQL query as follows to avoid SQL injection
    cursor.execute(sql_reservation, data_reservation)
    #cursor.execute(sql_date_interval, data_date_interval)

    # Commit the update (without this step the database will not change)
    connection.commit()

    # Closing connection
    cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred in the input of the querry.</h1>')
    print('<p>{}</p>'.format(e))

finally:
    if connection is not None:
        connection.close()
print("""
    <button class="ui primary basic button">
        <a href="home.cgi">Home</a>
    </button>
""")
print('</body>')
print('</html>')