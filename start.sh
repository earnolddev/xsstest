#!/bin/bash

phantomjs /opt/flaskapp/CTF_app_xss1/xss.js &
python3 /opt/flaskapp/CTF_app_xss1/routes.py
