## Create a windows server
## Install Python
## Creat the index.html
# Start a python server
```sh
python -m http.server 8000
```

## Show the server is working

```sh
curl http://<windows_ip>:8000
example: curl http://34.193.213.234:8000/
```

## Set a new firewall rule for blocking the port

<It's a web server so it should be running on tcp>

# Show the site is blocked
