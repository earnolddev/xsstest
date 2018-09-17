#!/bin/bash

phantomjs /opt/flaskapp/CTF_app_xss1/xss.js &
python /opt/flaskapp/CTF_app_xss1/routes.py
