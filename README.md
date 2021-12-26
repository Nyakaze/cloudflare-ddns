# Cloudflare DDNS Updater

With this script you can update your Cloudflare entries with your dynamic DNS.
This script is for Linux an Windows script will come soon.

# Support Me
[![Buy me a coffee](https://user-images.githubusercontent.com/31509082/147411719-b037b419-c79a-489a-98c9-9b2b66bbdcc7.png)](https://ko-fi.com/imakaze)

# Usage Linux
It can be used via crontabs. You can specify how often it should be executed.

```bash
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday 7 is also Sunday on some systems)
# │ │ │ │ │ ┌───────────── command to issue                               
# │ │ │ │ │ │
# │ │ │ │ │ │
# * * * * * /bin/bash {Location of the script}
```
