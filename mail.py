import textwrap
from flask_mail import Message
from run import app, mail

# This function builds the plaintext template used to send booking confirmations
def build_booking_plaintext(BookingID, flights):
    # Build header of the email
    header = """\
    Thank you. Your booking is now confirmed!
    
    Booking ID: %s
    
    Your Itinerary
    -------------------------------------------------------------
    """
    header = header % (BookingID)
    # Build body of the email
    body = ""
    for index, flight in enumerate(flights):
        b = """\
        Flight %s
        
        From: %s
        To: %s
        Date: %s
        Departure Time: %s
        
        Class: %s
        Passenger: %s
        Flight Number: %s
        Duration: %s
        -------------------------------------------------------------
        """
        b = b % (index + 1, flight[0], flight[1], flight[2], flight[3], flight[4], flight[5], flight[6], flight[7])
        body += textwrap.dedent(b)
    # Build footer of the email
    footer = """\
    Thank you for using our service. If you have 
    any questions about your flight or booking
    please contact us by calling +1 319-834-0276
    or email us at hawkair2020@gmail.com.
    Have a nice day!
    """
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

# This function builds the HTML template used to send booking confirmations
def build_booking_html(BookingID, flights):
    # Build header of the email
    header = """\
    <!DOCTYPE html>
    <html>
    <head>
        <style>
        body {
            margin-top: 10px;
        }
        
        table {
            border-collapse: collapse;
        }
    
        td, th {
            text-align: left;
            padding-top: 4px;
            padding-bottom: 4px;
            width: 150px;
        }
        
        #tableone {
            color: #FFCE07;
            background-color: #FFFFFF;
        }
        
        #tabletwo tr:nth-child(odd) {
            background-color: #DDDDDD;
        }
        </style>
    </head>
    
    <body>
        <img src="https://i.imgur.com/8kOruHF.png" alt="" width="200">
        <hr width="600px" align="left">
        <h2>Thank you. Your booking is now confirmed!</h2>
        <h4>Booking ID: %s</h4>
        <p>
        <h4>Your Itinerary</h4>
        <hr width="600px" align="left">
    """
    header = header % (BookingID)
    # Build body of the email
    body = ""
    for index, flight in enumerate(flights):
        b = """\
        <table id="tableone">
        <tr>
            <th>Flight %s</th>
        </tr>
        </table>
        <p>
        <table id="tabletwo">
            <tr>
                <th>From</th>
                <th>To</th>
                <th>Date</th>
                <th>Departure Time</th>
            </tr>
            <tr>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
            </tr>
            <tr>
                <th>Class</th>
                <th>Passenger</th>
                <th>Flight Number</th>
                <th>Duration</th>
            </tr>
            <tr>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
            </tr>
        </table>
        <hr width="600px" align="left">
        """
        b = b % (index + 1, flight[0], flight[1], flight[2], flight[3], flight[4], flight[5], flight[6], flight[7])
        body += textwrap.dedent(b)
    # Build footer of the email
    footer = """\
        <p>
        Thank you for using our service. If you have any questions about your flight or booking<br>
        please contact us by calling <a href="tel:3198340276">+1 319-834-0276</a> or email us at <a href="mailto:hawkair2020@gmail.com?Subject=Question" target="_top">hawkair2020@gmail.com</a><br>
        Have a nice day!
        </p>
    </body>
    </html>
    """
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

# This function builds the plaintext template used to send support information
def build_support_plaintext(firstName, lastName, email, subject, message):
    # Build header of the email
    header = """\
    A user has a question!
    -------------------------------------------------------------
    """
    # Build body of the email
    body = """\
    First Name: %s
    Last Name: %s
    Email: %s
    
    Subject: %s
    Message: %s
    -------------------------------------------------------------
    """
    body = body % (firstName, lastName, email, subject, message)
    # Build footer of the email
    footer = """\
    We will try to get back to you soon as possible. 
    Due to limited number of workers and huge 
    demand for flying tickets, we usually respond 
    in 2-3 business days to your inquiry. If you 
    have an urgent matter, please call us or 
    see us in person by visiting our local office.
    Have a nice day!
    """
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

# This function builds the HTML template used to send support information
def build_support_html(firstName, lastName, email, subject, message):
    # Build header of the email
    header = """\
    <!DOCTYPE html>
    <html>
    <head>
        <style>
        body {
            margin-top: 10px;
        }
        </style>
    </head>
    
    <body>
        <img src="https://i.imgur.com/8kOruHF.png" alt="" width="200">
        <hr width="600px" align="left">
        <h3>A user has a question!</h3>
    """
    # Build body of the email
    body = """\
        <p><strong>First Name:</strong> %s
        <br/>
        <strong>Last Name:</strong> %s
        <br/>
        <strong>Email:</strong> %s
        <br/>
        <br/>
        <strong>Subject:</strong> %s
        <br/>
        <strong>Message:</strong> %s
        </p>
        <hr width="600px" align="left">
    """
    body = body % (firstName, lastName, email, subject, message)
    # Build footer of the email
    footer = """\
        <p>
        We will try to get back to you soon as possible. Due to limited number of workers and huge <br>
        demand for flying tickets, we usually respond in 2-3 business days to your inquiry. If you <br>
        have an urgent matter, please call us or see us in person by visiting our local office. <br>
        Have a nice day!
        </p>
    </body>
    </html>
    """
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

def build_username_plaintext(username):
    # Build header of the email
    header = """\
    Forgot Username
    -------------------------------------------------------------
    """
    # Build body of the email
    body = """\
    We received a request to recover a username associated with your account.
    According to our records, your username is: %s
    -------------------------------------------------------------
    """
    body = body % (username)
    # Build footer of the email
    footer = """\
    Thank you for using our service. If you have 
    any questions about your flight or booking
    please contact us by calling +1 319-834-0276
    or email us at hawkair2020@gmail.com.
    Have a nice day!
    """
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

def build_username_html(username):
    # Build header of the email
    header = """\
    <!DOCTYPE html>
    <html>
    <head>
        <style>
        body {
            margin-top: 10px;
        }
        </style>
    </head>
    
    <body>
    """
    # Build body of the email
    body = """\
        <img src="https://i.imgur.com/8kOruHF.png" alt="" width="200">
        <hr width="600px" align="left">
        <h3>Forgot Username</h3>
        <p>We received a request to recover a username associated with your account.
        <br>
        According to our records, your username is: <strong>%s</strong>
        </p>
        <hr width="600px" align="left">
        <p>
    """
    body = body % (username)
    
    # Build footer of the email
    footer = """\
        <p>
        Thank you for using our service. If you have any questions about your flight or booking<br>
        please contact us by calling <a href="tel:3198340276">+1 319-834-0276</a> or email us at <a href="mailto:hawkair2020@gmail.com?Subject=Question" target="_top">hawkair2020@gmail.com</a><br>
        Have a nice day!
        </p>
    </body>
    </html>
    """
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

def build_password_plaintext(link):
    # Build header of the email
    header = """\
    Reset Your Password
    -------------------------------------------------------------
    """
    # Build body of the email
    body = """\
    To reset your password, click the following link:
    %s

    Please note that for security purposes, this link will expire 
    after 1 hour from the time it was sent.
    If you cannot access this link, then copy and paste 
    the entire URL into your browser.
    -------------------------------------------------------------
    """
    body = body % (link)
    # Build footer of the email
    footer = """\
    Thank you for using our service. If you have 
    any questions about your flight or booking
    please contact us by calling +1 319-834-0276
    or email us at hawkair2020@gmail.com.
    Have a nice day!
    """
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

def build_password_html(link):
    # Build header of the email
    header = """\
    <!DOCTYPE html>
    <html>
    <head>
        <style>
        body {
            margin-top: 10px;
        }
        </style>
    </head>
    
    <body>
    """
    # Build body of the email
    body = """\
        <img src="https://i.imgur.com/8kOruHF.png" alt="" width="200">
        <hr width="600px" align="left">
        <h3>Reset Your Password</h3>
        <p>To reset your password, click <a href="%s">here</a>
        <br>
        Please note that for security purposes, this link will expire after 1 hour from the time it was sent.
        <br>
        If you cannot access this link, then copy and paste the entire URL into your browser.
        </p>
        <hr width="600px" align="left">
        <p>
    """
    body = body % (link)
    
    # Build footer of the email
    footer = """\
        <p>
        Thank you for using our service. If you have any questions about your flight or booking<br>
        please contact us by calling <a href="tel:3198340276">+1 319-834-0276</a> or email us at <a href="mailto:hawkair2020@gmail.com?Subject=Question" target="_top">hawkair2020@gmail.com</a><br>
        Have a nice day!
        </p>
    </body>
    </html>
    """
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

# Function used to send emails
# It takes three parameters:
# Subject - subject of the email
# Receiver - receiver of the email
# Plaintext - plain text content of the email
# HTML - HTML content of the email
def send_mail(subject, receiver, plaintext, html=None):
    try:
        # Fill out the email fields
        message = Message()
        message.subject = subject
        message.sender = ("HawkAir", "hawkair2020@gmail.com")
        message.add_recipient(receiver)
        # Add HTML/plain-text parts to  message
        message.body = plaintext
        if html is not None:
            message.html = html
        # Send email
        with app.app_context():
            mail.send(message)
        return 200
    except Exception as e:
        return 500
