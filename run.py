from flask import *
from flask_bootstrap import *

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html", title='Home')

@app.route("/about-us")
def aboutUs():
    return render_template("about-us.html", title='About Us')

@app.route("/contact-us")
def contactUs():
    data = {
        "phone_number": "319-834-0276",
        "email": "hawkair2020@gmail.com"
    }
    return render_template("contact-us.html", title='Contact Us', data=data)

@app.route("/login")
def login():
    return render_template("login.html", title='Login / Sign Up')

if __name__ == "__main__":
    app.run(debug=True, host='127.0.0.1', port=5000)