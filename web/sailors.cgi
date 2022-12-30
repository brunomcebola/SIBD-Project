#!/usr/bin/python3
import psycopg2
import login

print('Content-type:text/html; charset=utf-8\n\n')
print('<html>')
print('<head>')
print('<title>Sailor</title>')
print("""<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />""")
print('</head>')
print('<body>')
print('<h3>Sailor</h3>')
connection = None

try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    # Making query
    sql = 'SELECT firstname, surname, email FROM sailor;'
    cursor.execute(sql)
    result = cursor.fetchall()
    num = len(result)

    # Create Sailor
    print('<a href="create_sailor_form.cgi">Create Sailor</a>')
    # Displaying results
    print("""
        <table class="ui celled table">
            <thead>
                <tr><th>First Name</th>
                <th>Surname</th>
                <th>Email</th>
                <th>Remove Sailor</th>
            </tr></thead>
            <tbody> 
    """)
    for row in result:
        print('<tr>')
        for value in row:
            # The string has the {}, the variables inside format() will replace the {}
            print('<td>{}</td>'.format(value))
        # Remove Sailor
        print('<td><a href="delete_sailor.cgi?email={}">Remove Sailor</a></td>'.format(row[2]))

        print('</tr>')

    print("</tbody>")
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