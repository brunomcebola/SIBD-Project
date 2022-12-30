#!/usr/bin/python3
import psycopg2
import login

print('Content-type:text/html; charset=utf-8\n\n')
print('<html>')
print('<head>')
print('<title>Sailors Authenticator</title>')
print("""<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />""")
print('</head>')
print('<body>')
print('<h3>Sailors Authenticator</h3>')
connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT * FROM authorised;'
    cursor.execute(sql)
    result = cursor.fetchall()
    num = len(result)

    # Create Sailor
    print('<a href="auth_sailor_form.cgi">Authorise Sailor</a>')
    # Displaying results
    print("""
        <table class="ui celled table">
            <thead>
                <tr><th>Start Date</th>
                <th>End Date</th>
                <th>Boat Country</th>
                <th>CNI</th>
                <th>Sailor's Email</th>
                <th>Remove Reservation</th>
            </tr></thead>
            <tbody> 
    """)
    for row in result:
        print('<tr>')
        for value in row:
            # The string has the {}, the variables inside format() will replace the {}
            print('<td>{}</td>'.format(value))
        
        # Remove Sailor
        print('<td><a href="deauth_sailor.cgi?start_date={}&end_date={}&country={}&cni={}&email={}">Remove Reservation</a></td>'.format(row[0],row[1],row[2],row[3], row[4] ))
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
    <button class="ui primary basic button">
        <a href="home.cgi">Home</a>
    </button>
""")
print('</body>')
print('</html>')