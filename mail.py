import ssl
import smtplib
import textwrap
from email.header import Header
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

sender = "hawkair2020@gmail.com"
password = "H@wkAir2020"

# This function validates all parameters used in this script
def validate(BookingID, flights):
    if not isinstance(BookingID, str):
        raise TypeError("BookingID has to be a string")
    if len(flights) == 0:
        raise ValueError("A list of flights cannot be empty")
    for flight in flights:
        if len(flight) != 9:
            raise ValueError("A flight must have 9 parameters")

# This function builds the plaintext template used to send booking confirmations
# Templete inside the static folder
def build_plaintext(BookingID, flights):
    # Build header of the email
    header = """\
    Thank you. Your reservation is now confirmed!
    
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
        Date: %s
        
        From: %s
        To: %s
        Departure Time: %s
        Duration: %s
        
        Flight Number: %s
        Aircraft: %s
        Class: %s
        Seat: %s
        -------------------------------------------------------------
        """
        b = b % (index + 1, flight[0], flight[1], flight[2], flight[3], flight[4], flight[5], flight[6], flight[7], flight[8])
        body += textwrap.dedent(b)
    # Build footer of the email
    footer = """\
    Thank you for using our service. If you have 
    any questions about your flight or reservation
    please contact us by calling +1 319-834-0276
    or email us at hawkair2020@gmail.com.
    Have a nice day!"""
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

# This function builds the HTML template used to send booking confirmations
# Templete inside the static folder
def build_html(BookingID, flights):
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
        <img src="https://i.imgur.com/8kOruHF.png" alt="" width="200" height="">
        <hr width="600px" align="left">
        <h2>Thank you. Your reservation is now confirmed!</h2>
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
            <th style="width: 450px;">Date: %s</th>
        </tr>
        </table>
        <p>
        <table id="tabletwo">
            <tr>
                <th>From</th>
                <th>To</th>
                <th>Departure Time</th>
                <th>Duration</th>
            </tr>
            <tr>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
                <td>%s</td>
            </tr>
            <tr>
                <th>Flight Number</th>
                <th>Aircraft</th>
                <th>Class</th>
                <th>Seat</th>
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
        b = b % (index + 1, flight[0], flight[1], flight[2], flight[3], flight[4], flight[5], flight[6], flight[7], flight[8])
        body += textwrap.dedent(b)
    # Build footer of the email    
    footer = """\
    <p>
    Thank you for using our service. If you have any questions about your flight or reservation<br>
    please contact us by calling <a href="tel:3198340276">+1 319-834-0276</a> or email us at <a href="mailto:hawkair2020@gmail.com?Subject=Question" target="_top">hawkair2020@gmail.com</a><br>
    Have a nice day!
    </body>
    </html>"""
    return textwrap.dedent(header) + textwrap.dedent(body) + textwrap.dedent(footer)

# This function takes three parameters:
# Receiver - receiver of the email
# Subject - subject of the email
# Plaintext - plain text content of the email
# HTML - HTML content of the email
def send_mail(receiver, subject, plaintext, html):
    try:
        # Fill out the email fields
        message = MIMEMultipart("alternative")
        message['Subject'] = Header(subject, 'utf-8')
        message['From'] = Header("HawkAir", 'utf-8')
        message['To'] = Header(receiver, 'utf-8')
        # Turn these into plain/html MIMEText objects
        part1 = MIMEText(plaintext, "plain", 'utf-8')
        part2 = MIMEText(html, "html", 'utf-8')
        # Add HTML/plain-text parts to MIMEMultipart message
        # The email client will try to render the last part first
        message.attach(part1)
        message.attach(part2)
        # Create secure connection with server and send email
        context = ssl.create_default_context()
        with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
            server.login(sender, password)
            server.sendmail(sender, receiver, message.as_string())
        print("Email sent succesfully!")
        return 200
    except Exception as e:
        print(e)
        return 503

############################################################################
################################# Test #####################################
############################################################################
BookingID = "000014"
flights = [["Tuesday, May 14, 2020", "ORD", "JFK", "14:00", "2:08h", "AA2470", "Boeing 737", "Economy", "26C"],
           ["Tuesday, May 14, 2020", "JFK", "MIA", "18:40", "3:02h", "AA5570", "Boeing 777", "Economy", "34A"]]

validate(BookingID, flights)
plaintext = build_plaintext(BookingID, flights)
html = build_html(BookingID, flights)

send_mail("piotrsmietana1998@gmail.com", "Your Booking Information", plaintext, html)
