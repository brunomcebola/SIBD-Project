#!/usr/bin/python3
print('Content-type:text/html\n\n')

print(""" 
<html>
    <head>
        <title>Create Sailor Form</title>
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
                <a class="active item" href="sailors.cgi">Sailors</a>
                <a class="item" href="reservations.cgi" >Reservations</a>
                <a class="item" href="sailors_auth.cgi">Authorised Sailors</a>
                <a class="item" href="trips.cgi">Trips</a>
            </div>
            <div class="content">
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
                                <label>Type</label>
                                <select name="sailor_type">
                                    <option value="junior">junior</option>
                                    <option value="senior">senior</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <button class="ui button" type="submit">Submit</button>
                </form>
            </div>
        </div>
    </body>
</html>
""")