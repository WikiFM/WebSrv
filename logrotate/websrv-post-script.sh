#!/bin/bash
/bin/kill -USR1 $(cat /var/run/nginx.pid)
