import hashlib
from flask import *

# My files
from forms import *
from mail import *
from run import app, mysql

# This data is avalible on every page
@app.context_processor
def globalData():
    try:
        # Fetch contact and company details from database
        cursor = mysql.connection.cursor()
        cursor.callproc("GetContactDetails")
        contact = cursor.fetchone()
        cursor.close()
        return dict(contact=contact)
    except:
        abort(500)

# Before each request check if a logged user is still in the database
# Prevents deleted and changed account from still being logged in
@app.before_request
def before_request():
    try:
        cursor = mysql.connection.cursor()
        cursor.callproc("ValidateUser", [session.get('user')])
        found = cursor.fetchone()
        cursor.close()
    except:
        abort(500)
    if not found:
        session.pop("user", None)

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
    # If a user submits one of the forms
    # Naming has to include a form number at the end to have multiple on one page
    if roundtrip.submit1.data and roundtrip.validate_on_submit():
        return roundtrip.data
    elif oneway.submit2.data and oneway.validate_on_submit():
        return oneway.data
    elif yourtrip.submit3.data and yourtrip.validate_on_submit():
        return yourtrip.data
    elif flightstatusDate.submit4.data and flightstatusDate.validate_on_submit():
        return flightstatusDate.data
    elif flightstatusNumber.submit5.data and flightstatusNumber.validate_on_submit():
        return flightstatusNumber.data
    return render_template("index.html", title="Home", index=True, news=news, roundtrip=roundtrip, oneway=oneway, yourtrip=yourtrip, flightstatusDate=flightstatusDate, flightstatusNumber=flightstatusNumber)

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
        # Validate, build and send the email
        validate_support(firstName, lastName, email, subject, message)
        plaintext = build_support_plaintext(firstName, lastName, email, subject, message)
        html = build_support_html(firstName, lastName, email, subject, message)
        response = send_mail("Support Question", email, plaintext, html)
        # Check the response and gives feedback to the user
        if response == "200":
            flash("Your contact form has been successfully submitted!", "success")
            return redirect(url_for("contactUs"))
        else: 
            flash("There was an error when processing the form. Please try again.", "danger")
            return redirect(url_for("contactUs"))
    return render_template("contact-us.html", title="Contact Us", contactus=True, form=form)

# Login page
@app.route("/login", methods=["GET", "POST"])
def login():
    # Check if user is already logged in
    if "user" in session:
        return redirect(url_for("dashboard"))
    # Form displayed on this page
    form = LoginForm()
    # If a user submits the form
    if form.validate_on_submit():
        try:
            session.pop("user", None)
            cursor = mysql.connection.cursor()
            cursor.callproc("ValidateUser", [form.username.data])
            found = cursor.fetchone()
            cursor.close()
        except:
            abort(500)
        # If user is found
        if found:
            hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
            # Check if password matches
            if hashedPassword == found['Password']:
                # Check if user ticked remember me
                if form.remember.data:
                    # Make the session permanent
                    session.permanent = True
                    session['user'] = form.username.data
                    return redirect(url_for("dashboard"))
                else:
                    session.permanent = False
                    session['user'] = form.username.data
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
    session.pop("user", None)
    flash("You have been successfully logged out !", "success")
    return redirect(url_for("index"))

# Dashboard
@app.route("/dashboard")
def dashboard():
    # Check if user is already logged in
    if "user" in session:
        try:
            # Get info and trips for this user
            cursor = mysql.connection.cursor()
            cursor.callproc("MyInfo", [session['user']])
            info = cursor.fetchone()
            cursor.nextset()
            cursor.callproc("MyTrips", [session['user']])
            trips = cursor.fetchall()
        except:
            abort(500)
        # Build flights if trips are not empty
        if trips:
            flights = {}
            for trip in trips:
                if trip['BookingID'] not in flights:
                    flights[trip['BookingID']] = []
                    flights[trip['BookingID']].append([trip['From'], trip['To'], str(trip['DepartTime'])[:-3], str(trip['Duration'])[:-3] + "h", trip['FlightID'], trip['AircraftID'], trip['Class'], trip['SeatNumber']])
                else:
                    flights[trip['BookingID']].append([trip['From'], trip['To'], str(trip['DepartTime'])[:-3], str(trip['Duration'])[:-3] + "h", trip['FlightID'], trip['AircraftID'], trip['Class'], trip['SeatNumber']])
            trips = flights
        cursor.close()
        return render_template("dashboard.html", title="Dashboard", dashboard=True, info=info, trips=trips)
    else:
        flash("Please log in first!", "warning")
        return redirect(url_for("login"))

# Register page
@app.route("/register", methods=["GET", "POST"])
def register():
    # Check if user is already logged in
    if "user" in session:
        return redirect(url_for("dashboard"))
    # Form displayed on the page
    form = RegisterForm()
    # If a user submits the form
    if form.validate_on_submit():
        try:
            data = request.form
            cursor = mysql.connection.cursor()
            hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
            cursor.callproc("CreateUser", [data['title'], data['firstName'], data['middleName'], data['lastName'], data['preferredName'], data['sex'], data['dateOfBirth'], data['street'], data['city'],
                                           data['zipCode'], data['state'], data['country'], data['phone'], data['email'], data['username'], hashedPassword, data['securityQuestion'], data['securityAnswer']])
            mysql.connection.commit()
            cursor.close()
            flash('Your account has been created! You should be able to log in now.', 'success')
            return redirect(url_for('login'))
        except:
            abort(500)
    return render_template("register.html", title="Register", login=True, form=form)

# Multicity page
@app.route("/multicity", methods=["GET", "POST"])
def multicity():
    try:
        # Get departure city locations from database
        cursor = mysql.connection.cursor()
        cursor.nextset()
        cursor.callproc("GetDepartLocations")
        fromCities = [(city['From'], city['From']) for city in cursor.fetchall()]
        # Get arrival city locations from database
        cursor.nextset()
        cursor.callproc("GetArrivalLocations")
        toCities = [(city['To'], city['To']) for city in cursor.fetchall()]
        cursor.close()
    except:
        abort(500)
    # Form displayed on the page
    form = MulticityForm()
    # If a user submits the form
    if form.validate_on_submit():
        return form.data
    return render_template("multicity.html", title="Multi-City", form=form)

# Admin page
@app.route("/admin", methods=["GET", "POST"])
def admin():
    # Form displayed on the page
    form = AdminForm()
    # If a user submits the form
    if form.validate_on_submit():
        hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
        return form.data
    return render_template("admin.html", title="Admin", form=form)

# Error 404
@app.errorhandler(404)
def page_not_found(e):
    return render_template("errors/404.html", title="Page Not Found")

# Error 500
@app.errorhandler(500)
def server_error(e):
    return render_template("errors/500.html", title="Server Error")
