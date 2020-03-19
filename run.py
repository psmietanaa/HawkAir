import hashlib

# Flask libraries
from flask import *
from flask_bootstrap import Bootstrap
from flask_mail import Mail

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

# Home page
@app.route("/", methods=["GET", "POST"])
def index():
    # We will fetch the latest 3 news from MySQL using ORDER BY
    news1 = {
        "headline": "May Vacation Sale",
        "picture": "/static/images/vacations.png",
        "content": "Save and earn up to 25,000 bonus miles when you book your flight and hotel together! MileagePlus is your ticket to the world, with the most ways to earn and use miles and the most award destinations of any U.S. airline loyalty program. Now all you need is more vacation days."
    }
    news2 = {
        "headline": "Rent a Car with Avis or Budget",
        "picture": "/static/images/car.png",
        "content": "Save up to 35% off base rates and earn miles. Reserve a car today! No matter the destination, enjoy a trip that delivers more savings. Save up to 30% off of Budget base rates and earn 1,000 AAdvantage bonus miles when you rent for 4 or more days. These miles are in addition to your base miles you receive when renting with Budget."
    }
    news3 = {
        "headline": "Fly Nonstop to Poland",
        "picture": "/static/images/poland.png",
        "content": "New service to Krakow from Chicago OHare start May 7. Search and book your flights! Pack your bags and explore Europe! Take advantage of great fares and low exchange rates and save first on flights and again on hotels, dining and shopping when you get there."
    }
    news = [news1, news2, news3]
    
    # Forms displayed on this page
    roundtrip = RoundTripForm()
    oneway = OneWayForm()
    yourtrip = YourTripForm()
    flightstatusDate = FlightStatusDateForm()
    flightstatusNumber = FlightStatusNumberForm()
    # If a user submits one of the forms
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
    return render_template("index.html", title="Home", news=news, roundtrip=roundtrip, oneway=oneway, yourtrip=yourtrip, flightstatusDate=flightstatusDate, flightstatusNumber=flightstatusNumber)

# About us page
@app.route("/about-us")
def aboutUs():
    return render_template("about-us.html", title="About Us")

# Contact us page
@app.route("/contact-us", methods=["GET", "POST"])
def contactUs():
    # Fetch this data from our database
    data = {
        "phoneNumber": "319-834-0276",
        "email": "hawkair2020@gmail.com"
    }
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
            return redirect(url_for('contactUs'))
        else: 
            flash("There was an error when processing the form. Please try again.", "error")
            return redirect(url_for('contactUs'))            
    return render_template("contact-us.html", title="Contact Us", data=data, form=form)

# Login page
@app.route("/login", methods=["GET", "POST"])
def login():
    # Form displayed on this page
    form = LoginForm()
    # If a user submits the form
    if form.validate_on_submit():
        hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
        return form.data
    return render_template("login.html", title="Login / Register", form=form)

# Register page
@app.route("/register", methods=["GET", "POST"])
def register():
    # Form displayed on the page
    form = RegisterForm()
    # If a user submits the form
    if form.validate_on_submit():
        hashedPassword = hashlib.sha256(form.password.data.encode()).hexdigest()
        return form.data
    return render_template("register.html", title="Register", form=form)

# Multicity page
@app.route("/multicity", methods=["GET", "POST"])
def multicity():
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

# Main function
if __name__ == "__main__":
    app.run(debug=True, host="127.0.0.1", port=5000)
