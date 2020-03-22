# Flask libraries
import hashlib
from flask import *
from flask_bootstrap import Bootstrap
from flask_mail import Mail
from flask_mysqldb import MySQL

# My files
from forms import *
from mail import *

# Base config
app = Flask(__name__)
app.config["SECRET_KEY"] = "CS4400"
bootstrap = Bootstrap(app)

# Mail server
app.config["MAIL_SERVER"] = "smtp.gmail.com"
app.config["MAIL_PORT"] = 465
app.config["MAIL_USE_SSL"] = True
app.config["MAIL_USERNAME"] = "hawkair2020@gmail.com"
app.config["MAIL_PASSWORD"] = "H@wkAir2020"
mail = Mail(app)

# MySQL config
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = "toor"
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_DB"] = "HawkAir"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"
mysql = MySQL(app)

# This data is avalible on every page
@app.context_processor
def globalData():
    try:
        # Fetch contact and company details from database
        cursor = mysql.connection.cursor()
        cursor.callproc("GetContactDetails")
        contact = cursor.fetchone()
        cursor.close()
    except:
        abort(500)
    return dict(contact=contact)

# Home page
@app.route("/", methods=["GET", "POST"])
def index():
    try:
        # Fetch three latest news from database
        cursor = mysql.connection.cursor()
        cursor.callproc("GetNews", [3])
        news = cursor.fetchall()
        # Get departure city locations from database
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
    # Forms displayed on this page
    roundtrip = RoundTripForm()
    roundtrip.fromCity1.choices = fromCities
    roundtrip.toCity1.choices = toCities
    oneway = OneWayForm()
    oneway.fromCity2.choices = fromCities
    oneway.toCity2.choices = toCities
    yourtrip = YourTripForm()
    flightstatusDate = FlightStatusDateForm()
    flightstatusDate.fromCity4.choices = fromCities
    flightstatusDate.toCity4.choices = toCities
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
        # Parse the fields
        firstName = form.firstName.data
        lastName = form.lastName.data
        email = form.email.data
        subject = form.subject.data
        message = form.message.data
        # Build and send the email
        validate_support(firstName, lastName, email, subject, message)
        plaintext = build_support_plaintext(firstName, lastName, email, subject, message)
        html = build_support_html(firstName, lastName, email, subject, message)
        response = send_mail("Support Question", email, plaintext, html)
        # Check the response and gives feedback to the user
        if response == "200":
            flash("Your contact form has been successfully submitted!", "success")
            return redirect(url_for("contactUs"))
        else: 
            flash("There was an error when processing the form. Please try again.", "error")
            return redirect(url_for("contactUs"))
    return render_template("contact-us.html", title="Contact Us", contactus=True, form=form)

# Login page
@app.route("/login", methods=["GET", "POST"])
def login():
    # Form displayed on this page
    form = LoginForm()
    # If a user submits the form
    if form.validate_on_submit():
        hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
        return form.data
    return render_template("login.html", title="Login / Register", login=True, form=form)

# Register page
@app.route("/register", methods=["GET", "POST"])
def register():
    # Form displayed on the page
    form = RegisterForm()
    # If a user submits the form
    if form.validate_on_submit():
        hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
        return form.data
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
    form.flights[0].fromCity.choices = fromCities
    form.flights[0].toCity.choices = toCities
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

# Error 403
@app.errorhandler(403)
def forbidden(e):
    return render_template("errors/403.html", title="Forbidden")

# Error 404
@app.errorhandler(404)
def page_not_found(e):
    return render_template("errors/404.html", title="Page Not Found")

# Error 500
@app.errorhandler(500)
def server_error(e):
    return render_template("errors/500.html", title="Server Error")

# Main function
if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=5000)
