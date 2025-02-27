from flask import *
from helper import *
from forms import *
from mail import *
from run import app, mysql

# This data is avalible on every page
@app.context_processor
def globalData():
    try:
        # Fetch company details from database
        cursor = mysql.connection.cursor()
        cursor.callproc("GetContactDetails")
        contact = cursor.fetchone()
        cursor.close()
        return dict(contact=contact)
    except:
        abort(500)

# Before each request check if a logged user is still in the database
# Prevents deleted and changed accounts from still being logged in
@app.before_request
def before_request():
    try:
        cursor = mysql.connection.cursor()
        cursor.callproc("ValidateUser", [session.get('username')])
        found = cursor.fetchone()
        cursor.close()
        # If not found
        if not found:
            # Pop the user from session
            session.pop("username", None)
            session.pop("userID", None)
    except:
        abort(500)

# Home page
@app.route("/", methods=["GET", "POST"])
def index():
    try:
        # Get three latest news from database
        cursor = mysql.connection.cursor()
        cursor.callproc("GetNews", [3])
        news = cursor.fetchall()
        cursor.close()
    except:
        abort(500)
    # Forms displayed on this page
    roundtrip = RoundTripForm()
    oneway = OneWayForm()
    yourtrip = YourTripForm()
    flightstatusDate = FlightStatusDateForm()
    flightstatusNumber = FlightStatusNumberForm()
    session.pop("changeFlight", None)
    # If a user submits one of the forms
    # Naming has to include a form number at the end to have multiple forms on one page
    if roundtrip.submit1.data and roundtrip.validate_on_submit():
        # Build flights based on the form
        data = roundtrip.data
        flights = []
        flights.append({'from': data['fromCity1'], 'to': data['toCity1'], 'passengers': data['passengers1'], 'date': str(data['departDate1'])})
        flights.append({'from': data['toCity1'], 'to': data['fromCity1'], 'passengers': data['passengers1'], 'date': str(data['returnDate1'])})
        session['selectFlight'] = flights
        session['passengers'] = int(data['passengers1'])
        # User must be logged in to search flights
        if "username" in session:
            return redirect(url_for("selectFlight"))
        else:
            flash("Please log in first!", "warning")
            return redirect(url_for("login", next=url_for("selectFlight")))
    elif oneway.submit2.data and oneway.validate_on_submit():
        # Build flights based on the form
        data = oneway.data
        flights = []
        flights.append({'from': data['fromCity2'], 'to': data['toCity2'], 'passengers': data['passengers2'], 'date': str(data['departDate2'])})
        session['selectFlight'] = flights
        session['passengers'] = int(data['passengers2'])
        # User must be logged in to search flights
        if "username" in session:
            return redirect(url_for("selectFlight"))
        else:
            flash("Please log in first!", "warning")
            return redirect(url_for("login", next=url_for("selectFlight")))
    elif yourtrip.submit3.data and yourtrip.validate_on_submit():
        data = yourtrip.data
        try:
            # Get trip info for user
            cursor = mysql.connection.cursor()
            cursor.callproc("YourTrip", [data['firstName3'], data['lastName3'], data['bookingNumber3']])
            trips = cursor.fetchall()
            cursor.close()
        except:
            abort(500)
        # Build flights if trips are not empty
        if trips:
            trips = buildTrips(trips)
        return render_template("your-trip.html", title="Your Trip", trips=trips)
    elif flightstatusDate.submit4.data and flightstatusDate.validate_on_submit():
        data = flightstatusDate.data
        try:
            # Get flight status info for user
            cursor = mysql.connection.cursor()
            cursor.callproc("GetFlightsStatusDate", [data['fromCity4'], data['toCity4'], data['date4']])
            trips = cursor.fetchall()
            cursor.close()
        except:
            abort(500)
        # Build flights if trips are not empty
        if trips:
            trips = buildStatus(trips)
        return render_template("flight-status.html", title="Flight Status", trips=trips)
    elif flightstatusNumber.submit5.data and flightstatusNumber.validate_on_submit():
        data = flightstatusNumber.data
        try:
            # Get flight status info for user
            cursor = mysql.connection.cursor()
            cursor.callproc("GetFlightsStatusNumber", [data['flightNumber5'], data['date5']])
            trips = cursor.fetchall()
            cursor.close()
        except:
            abort(500)
        # Build flights if trips are not empty
        if trips:
            trips = buildStatus(trips)
        return render_template("flight-status.html", title="Flight Status", trips=trips)
    return render_template("index.html", title="Home", index=True, news=news, roundtrip=roundtrip, oneway=oneway, yourtrip=yourtrip, flightstatusDate=flightstatusDate, flightstatusNumber=flightstatusNumber)

# Select flight
@app.route("/select-flight", methods=["GET", "POST"])
def selectFlight(flights = []):
    # If user selected flights
    if request.method == "POST":
        flights = session.get("buildFlight", None)
        data = getValues(request.form)
        # Update flights based on user seletion
        chosen = []
        for i in range(0, len(data)):
            index = int(data[i])
            chosen.append(flights[i][index])
        # Check if the returning flight is after departing flight for a round trip
        if len(chosen) == 2:
            departDate = chosen[0]['Date']
            departTime = chosen[0]['DepartTime']
            departDuration = chosen[0]['Duration']
            returnDate = chosen[1]['Date']
            returnTime = chosen[1]['DepartTime']
            if not validateRoundTrip(departDate, departTime, departDuration, returnDate, returnTime):
                flash("Returning flight must be after departing flight. Please select again.", "danger")
                return redirect(url_for("selectFlight"))
        session['chosenFlight'] = chosen
        # If a user is changing a flight
        if "changeFlight" in session:
            changeFlightDetails = session.get("changeFlightDetails", None)
            chosenFlight = session.get("chosenFlight", None)[0]
            try:
                cursor = mysql.connection.cursor()
                cursor.callproc("UpdateBooking", [changeFlightDetails['bookingID'], changeFlightDetails['flightID'], changeFlightDetails['passenger'], changeFlightDetails['date'], chosenFlight['FlightID'], chosenFlight['Date']])
                mysql.connection.commit()
                cursor.close()
            except:
                abort(500)
            # If success redirect to dashboard
            session.pop("selectFlight", None)
            session.pop("changeFlight", None)
            session.pop("changeFlightDetails", None)
            flash("Booking successfully changed.", "success")
            return redirect(url_for("dashboard"))
        else:
            return redirect(url_for("chooseFares"))
    elif "selectFlight" in session:
        data = session.get("selectFlight", None)
        passengers = session.get("passengers", None)
        flights = []
        for i in range(0, len(data)):
            flight = []
            try:
                # Search for flights
                cursor = mysql.connection.cursor()
                cursor.callproc("SearchFlights", [data[i]['from'], data[i]['to'], toWeekday(data[i]['date'])])
                search = [i['FlightID'] for i in cursor.fetchall()]
                cursor.close()
            except:
                abort(500)
            for j in range(0, len(search)):
                try:
                    # Check if there are available seats for each flight
                    cursor = mysql.connection.cursor()
                    cursor.callproc("CheckSeats", [search[j], data[i]['date'], passengers])
                    seats = cursor.fetchone()
                    cursor.close()
                except:
                    abort(500)
                # Build flights if there are seats for that flight
                if seats:
                    flight.append(seats)
            # Add this flight to all displayed flights if we found seats
            if flight != []:
                flights.append(buildFlight(flight, data[i]['date']))
        session['buildFlight'] = flights
        return render_template("select-flight.html", title="Select Flights", flights=flights)
    else:
        return redirect(url_for("index"))

# Choose fares
@app.route("/choose-fares", methods=["GET", "POST"])
def chooseFares():
    # If user chose fares
    if request.method == "POST":
        data = getValues(request.form)
        fares = session.get("chooseFares", None)
        # Update fares based on user seletion
        chosen = []
        for i in range(0, len(data)):
            index = int(data[i])
            if index % 2 == 0:
                chosen.append([fares[i][0], "Economy", fares[i][1][1]])
            else:
                chosen.append([fares[i][0], "First Class", fares[i][2][1]])
        session['payment'] = chosen
        return redirect(url_for("passengers"))
    # Call procedure to get fares
    elif "buildFlight" in session:
        flights = session.get("chosenFlight", None)
        passengers = session.get("passengers", None)
        # Get fare for each flight
        fares = []
        for flight in flights:
            cursor = mysql.connection.cursor()
            cursor.callproc("GetFare", [flight['FlightID']])
            fare = cursor.fetchone()
            cursor.close()
            # Build fare for each flight
            builder = [flight['FlightID']]
            # Check if we can fit passengers in economy
            if flight['AvailableEconomySeats'] >= passengers:
                builder.append([str(fare['PriceEconomy']), str(int(fare['PriceEconomy']) * passengers)])
            else:
                builder.append([None, None])
            # Check if we can fit passengers in first class
            if flight['AvailableFirstClassSeats'] >= passengers:
                builder.append([str(fare['PriceFirstClass']), str(int(fare['PriceFirstClass']) * passengers)])
            else:
                builder.append([None, None])
            fares.append(builder)
        session['chooseFares'] = fares
        return render_template("choose-fares.html", title="Choose Fares", fares=fares)
    else:
        return redirect(url_for("index"))

# Passengers
@app.route("/passengers", methods=["GET", "POST"])
def passengers():
    if "passengers" in session:
        passengers = session.get("passengers", None)
        # Payment form
        form = PassengersForm()
        if len(form.passengers) < passengers:
            for i in range(0, passengers):
                form.passengers.append_entry()
        # If user entered passengers details
        if form.validate_on_submit():
            data = form.passengers.data
            session['passengerDetails'] = data
            return redirect(url_for("payment"))
        return render_template("passengers.html", title="Passengers", passengers=passengers, form=form)
    else:
        return redirect(url_for("index"))

# Checkout
@app.route("/payment", methods=["GET", "POST"])
def payment():
    if "payment" in session:
        data = session.get("payment", None)
        # Sum up all the flights
        total = 0
        for flight in data:
            total += int(flight[2])
        # Payment form
        form = PaymentForm()
        # If user entered payment details
        if form.validate_on_submit():
            # Authenticate payment
            authenticatePayment()
            try:
                # Get list of all taken bookingIDs
                cursor = mysql.connection.cursor()
                cursor.callproc("GetBookingIDs")
                ids = cursor.fetchall()
                cursor.close()
            except:
                abort(500)
            # Generate a unique bookingID
            bookingID = generateBookingID(ids)
            userID = session.get("userID", None)
            selectFlight = session.get("selectFlight", None)
            passengers = session.get("passengerDetails", None)
            payment = session.get("payment", None)
            # Book flights for each passengers
            try:
                cursor = mysql.connection.cursor()
                cursor.callproc("CreateBooking", [bookingID, userID])
                mysql.connection.commit()
                cursor.close()
            except:
                abort(500)            
            for i in range(0, len(selectFlight)):
                for j in range(0, len(passengers)):
                    try:
                        cursor = mysql.connection.cursor()
                        cursor.callproc("CreateMultipleBookings", [bookingID, payment[i][0], selectFlight[i]['date'], passengers[j]['firstName'] + " " + passengers[j]['lastName'], payment[i][1]])
                        mysql.connection.commit()
                        cursor.close()
                    except:
                        abort(500)
            # If success redirect to confirmation
            session['bookingID'] = bookingID
            return redirect(url_for("confirmation"))
        return render_template("payment.html", title="Payment", total=total, form=form)
    else:
        return redirect(url_for("index"))

# confirmation
@app.route("/confirmation", methods=["GET", "POST"])
def confirmation():
    # If a user decides to send an email
    if request.method == "POST":
        try:
            # Get info and trips for this user
            cursor = mysql.connection.cursor()
            cursor.callproc("MyInfo", [session['username']])
            info = cursor.fetchone()
            cursor.nextset()
            cursor.callproc("GetBooking", [session['bookingID']])
            bookings = cursor.fetchall()
            cursor.close()
        except:
            abort(500)
        # Build bookings if not empty
        if bookings:
            bookings = buildTrips(bookings)
            plaintext = build_booking_plaintext(session['bookingID'], bookings[session['bookingID']])
            html = build_booking_html(session['bookingID'], bookings[session['bookingID']])
            response = send_mail("Your Booking Confirmation", info['Email'], plaintext, html)
            # Check the response and give feedback to the user
            if response == 200:
                flash("Email with your booking confirmation has been sent! Check you inbox.", "success")
                return render_template("confirmation.html", title="Your Booking Confirmation", bookingID=session['bookingID'], bookings=bookings)
            else:
                flash("There was an error when sending the email. Please try again.", "danger")
                return render_template("confirmation.html", title="Your Booking Confirmation", bookingID=session['bookingID'], bookings=bookings)
        else:
            flash("There was an error when sending the email. Please try again.", "danger")
            return render_template("confirmation.html", title="Your Booking Confirmation", bookingID=session['bookingID'], bookings=bookings)
    elif "bookingID" in session:
        bookingID = session.get("bookingID", None)
        # Get all booked flights
        try:
            cursor = mysql.connection.cursor()
            cursor.callproc("GetBooking", [bookingID])
            bookings = cursor.fetchall()
            cursor.close()
        except:
            abort(500)
        # Build bookings if not empty
        if bookings:
            bookings = buildTrips(bookings)
        # Pop all the cookies used to create booking
        session.pop("selectFlight", None)
        session.pop("buildFlight", None)
        session.pop("chosenFlight", None)
        session.pop("chooseFares", None)
        session.pop("passengers", None)
        session.pop("passengerDetails", None)
        session.pop("payment", None)
        return render_template("confirmation.html", title="Your Booking Confirmation", bookingID=bookingID, bookings=bookings)
    else:
        return redirect(url_for("index"))

# Your trip
@app.route("/your-trip")
def yourTrip():
    # Should not be accesses directly
    return redirect(url_for("index"))

# Flight status
@app.route("/flight-status")
def flightStatusDate():
    # Should not be accesses directly
    return redirect(url_for("index"))

# About us page
@app.route("/about-us")
def aboutUs():
    return render_template("about-us.html", title="About Us", aboutus=True)

# Contact us page
@app.route("/contact-us", methods=["GET", "POST"])
def contactUs():  
    # Form displayed on this page
    form = ContactForm()
    # If a user submits the form
    if form.validate_on_submit():
        # Parse the form fields
        firstName = form.firstName.data
        lastName = form.lastName.data
        email = form.email.data
        subject = form.subject.data
        message = form.message.data
        # Build and send email
        plaintext = build_support_plaintext(firstName, lastName, email, subject, message)
        html = build_support_html(firstName, lastName, email, subject, message)
        response = send_mail("Support Question", "hawkair2020@gmail.com", plaintext, html)
        # Check the response and give feedback to the user
        if response == 200:
            flash("Your contact form has been successfully submitted!", "success")
            return redirect(url_for("contactUs"))
        else: 
            flash("There was an error when processing the form. Please try again.", "danger")
            return redirect(url_for("contactUs"))
    return render_template("contact-us.html", title="Contact Us", contactus=True, form=form)

# Login page
@app.route("/login", methods=["GET", "POST"])
def login():
    # Check if user is logged in
    if "username" in session:
        return redirect(url_for("dashboard"))
    # Form displayed on this page
    form = LoginForm()
    # If a user submits the form
    if form.validate_on_submit():
        try:
            session.pop("username", None)
            session.pop("userID", None)
            cursor = mysql.connection.cursor()
            cursor.callproc("ValidateUser", [form.username.data])
            found = cursor.fetchone()
            cursor.close()
        except:
            abort(500)
        # If user is found
        if found:
            hashedPassword = hashPassword(form.password.data)
            # Check if password matches
            if hashedPassword == found['Password']:
                # Support for the next url
                next_url = request.form.get("next")
                # Check if user ticked remember me
                if form.remember.data:
                    if next_url:
                        # Make the session permanent
                        session.permanent = True
                        session['userID'] = found['UserID']
                        session['username'] = found['Username']
                        return redirect(next_url)
                    else:
                        # Make the session permanent
                        session.permanent = True
                        session['userID'] = found['UserID']
                        session['username'] = found['Username']
                        return redirect(url_for("dashboard"))
                else:
                    if next_url:
                        session.permanent = False
                        session['userID'] = found['UserID']
                        session['username'] = found['Username']
                        return redirect(next_url)
                    else:
                        session.permanent = False
                        session['userID'] = found['UserID']
                        session['username'] = found['Username']
                        return redirect(url_for("dashboard"))
            else:
                flash("Invalid password! Please try again.", "danger")
        else:
            flash("Invalid email or password! Please try again.", "danger")
    return render_template("login.html", title="Login / Register", login=True, form=form)

# Logout
@app.route("/logout")
def logout():
    # Delete this users cookie
    session.pop("username", None)
    session.pop("userID", None)
    flash("You have been successfully logged out !", "success")
    return redirect(url_for("index"))

@app.route("/forgot-username", methods=["GET", "POST"])
def forgotUsername():
    # Check if user is logged in
    if "username" in session:
        return redirect(url_for("dashboard"))
    # Form displayed on this page
    form = ForgotUsernameForm()
    # If a user submits the form
    if form.validate_on_submit():
        try:
            cursor = mysql.connection.cursor()
            cursor.callproc("RecoverCredentials", [form.email.data])
            found = cursor.fetchone()
            cursor.close()
        except:
            abort(500)
        # Send email with username
        plaintext = build_username_plaintext(found['Username'])
        html = build_username_html(found['Username'])
        response = send_mail("Forgot Username", form.email.data, plaintext, html)
        # Check the response and give feedback to the user
        if response == 200:
            flash("An email has been sent with your username.", "success")
            return redirect(url_for("login"))
        else:
            flash("There was an error when sending the email. Please try again.", "danger")
            return redirect(url_for("forgotUsername"))
    return render_template("forgot-username.html", title="Forgot Username", form=form)

@app.route("/forgot-password", methods=["GET", "POST"])
def forgotPassword():
    # Check if user is logged in
    if "username" in session:
        return redirect(url_for("dashboard"))
    # Form displayed on this page
    form = ForgotPasswordForm()
    # If a user submits the form
    if form.validate_on_submit():
        try:
            cursor = mysql.connection.cursor()
            cursor.callproc("RecoverCredentials", [form.email.data])
            found = cursor.fetchone()
            cursor.close()
        except:
            abort(500)
        # Create a link valid for one hour
        token = getResetToken(found['UserID'])
        link = url_for("resetPassword", token=token, _external=True)
        # Send email with password reset information
        plaintext = build_password_plaintext(link)
        html = build_password_html(link)
        response = send_mail("Reset Your Password", form.email.data, plaintext, html)
        # Check the response and give feedback to the user
        if response == 200:
            flash("An email has been sent with instructions to reset your password.", "success")
            return redirect(url_for("login"))
        else:
            flash("There was an error when sending the email. Please try again.", "danger")
            return redirect(url_for("forgotPassword"))
    return render_template("forgot-password.html", title="Reset My Password", form=form)

@app.route("/reset-password/<token>", methods=['GET', 'POST'])
def resetPassword(token):
    # Check if user is logged in
    if "username" in session:
        return redirect(url_for("dashboard"))
    # Verify the token
    UserID = verifyResetToken(token)
    if UserID is None:
        flash("That is an invalid or expired token", "danger")
        return redirect(url_for("login"))
    form = ResetPasswordForm()
    if form.validate_on_submit():
        hashedPassword = hashPassword(form.password.data)
        try:
            cursor = mysql.connection.cursor()
            cursor.callproc("ResetPassword", [UserID, hashedPassword])
            mysql.connection.commit()
            cursor.close()
        except:
            abort(500)
        flash("Your password has been updated! You should be able to log in now.", "success")
        return redirect(url_for("login"))
    return render_template("reset-password.html", title="Reset Your Password", form=form)

# Register page
@app.route("/register", methods=["GET", "POST"])
def register():
    # Check if user is logged in
    if "username" in session:
        return redirect(url_for("dashboard"))
    # Form displayed on the page
    form = RegisterForm()
    # If a user submits the form
    if form.validate_on_submit():
        try:
            data = request.form
            cursor = mysql.connection.cursor()
            hashedPassword = hashPassword(data['password'])
            cursor.callproc("CreateUser", [data['title'], data['firstName'], data['middleName'], data['lastName'],
                                           data['preferredName'], data['sex'], data['dateOfBirth'], data['street'], data['city'],
                                           data['zipCode'], data['state'], data['country'], data['phone'], data['email'],
                                           data['username'], hashedPassword, data['securityQuestion'], data['securityAnswer']])
            mysql.connection.commit()
            cursor.close()
            flash('Your account has been created! You should be able to log in now.', 'success')
            return redirect(url_for('login'))
        except:
            abort(500)
    return render_template("register.html", title="Register", login=True, form=form)


# Dashboard
@app.route("/dashboard", methods=["GET", "POST"])
def dashboard():
    # Check if user is logged in
    if "username" in session:
        try:
            # Get info and trips for this user
            cursor = mysql.connection.cursor()
            cursor.callproc("MyInfo", [session['username']])
            info = cursor.fetchone()
            cursor.nextset()
            cursor.callproc("MyTrips", [session['username']])
            trips = cursor.fetchall()
            cursor.close()
        except:
            abort(500)
        # Build flights if trips are not empty
        if trips:
            trips = buildTrips(trips)
        return render_template("dashboard.html", title="Dashboard", dashboard=True, info=info, trips=trips, minChangeBookingDate=minChangeBookingDate(), maxChangeBookingDate=maxChangeBookingDate())
    else:
        flash("Please log in first!", "warning")
        return redirect(url_for("login", next=request.url))

@app.route("/dashboard/change", methods=["GET", "POST"])
def changeBooking():
    # Check if user is logged in
    if "username" in session:
        bookingID = request.args.get("bookingID")
        flightID = request.args.get("flightID")
        passengerName = request.args.get("passengerName")
        fromCity = request.args.get("fromCity")
        toCity = request.args.get("toCity")
        date = request.args.get("date")
        newDate = request.form.get("newDate")
        if bookingID == None or flightID == None or passengerName == None:
            return redirect(url_for("dashboard"))
        else:
            try:
                # Check if user owns that booking
                cursor = mysql.connection.cursor()
                cursor.callproc("ValidateBookingChange", [session['username'], bookingID, flightID, passengerName])
                found = cursor.fetchone()
                cursor.close()
            except:
                abort(500)
            # Change flight is allowed if found
            if found:
                # Redirect just to seat selection
                flights = []
                flights.append({'from': fromCity, 'to': toCity, 'passengers': 1, 'date': newDate})
                session['selectFlight'] = flights
                session['passengers'] = 1
                session['changeFlight'] = True
                session['changeFlightDetails'] = {'bookingID': bookingID, 'flightID': flightID, 'passenger': passengerName, 'date': date}
                return redirect(url_for("selectFlight"))
            else:
                flash('You cannot change this flight.', 'danger')
                return redirect(url_for("dashboard"))
    else:
        return redirect(url_for("login", next=request.url))

@app.route("/dashboard/delete", methods=["GET", "POST"])
def deleteBooking():
    # Check if user is logged in
    if "username" in session:
        bookingID = request.args.get("bookingID")
        flightID = request.args.get("flightID")
        passengerName = request.args.get("passengerName")
        if bookingID == None or flightID == None or passengerName == None:
            return redirect(url_for("dashboard"))
        else:
            try:
                # Check if user owns that booking
                cursor = mysql.connection.cursor()
                cursor.callproc("ValidateBookingChange", [session['username'], bookingID, flightID, passengerName])
                found = cursor.fetchone()
                cursor.close()
            except:
                abort(500)
            # Cancel flight is allowed
            if found:
                try:
                    # Delete booking if found
                    cursor = mysql.connection.cursor()
                    cursor.callproc("DeleteBooking", [bookingID, flightID, passengerName])
                    mysql.connection.commit()
                    cursor.close()
                except:
                    abort(500)
                flash('Booking successfully deleted.', 'success')
                return redirect(url_for("dashboard"))
            else:
                flash('You cannot cancel this flight.', 'danger')
                return redirect(url_for("dashboard"))
    else:
        return redirect(url_for("login", next=request.url))

# Multicity page
@app.route("/multicity", methods=["GET", "POST"])
def multicity():
    # Form displayed on the page
    form = MulticityForm()
    # If a user submits the form
    if form.validate_on_submit():
        # Build flights based on the form
        flights = form.flights.data
        passengers = form.passengers.data
        data = []
        for flight in flights:
            data.append({'from': flight['fromCity'], 'to': flight['toCity'], 'passengers': passengers, 'date': str(flight['departDate'])})
        session['selectFlight'] = data
        session['passengers'] = int(passengers)
        if "username" in session:
            return redirect(url_for("selectFlight"))
        else:
            flash("Please log in first!", "warning")
            return redirect(url_for("login", next=url_for("selectFlight")))
    return render_template("multicity.html", title="Multi-City", form=form)

# Admin page
@app.route("/admin", methods=["GET", "POST"])
def admin():
    # Form displayed on the page
    form = AdminForm()
    # If a user submits the form
    if form.validate_on_submit():
        hashedPassword = hashPassword(form.password.data)
        return "Not implemented"
    return render_template("admin.html", title="Admin", form=form)

# Error 404
@app.errorhandler(404)
def page_not_found(e):
    return render_template("errors/404.html", title="Page Not Found")

# Error 500
@app.errorhandler(500)
def server_error(e):
    return render_template("errors/500.html", title="Server Error")
