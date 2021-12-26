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

# Using Discord
You can use Discord webhooks to get notified when something happens.
![Discord_Webhook](https://user-images.githubusercontent.com/31509082/147412335-6d3cd555-dfc8-45ba-a7aa-3cd04bb560f6.png)
![Discord_Webhook_2](https://user-images.githubusercontent.com/31509082/147412344-7bea872d-3ad5-4c87-a622-076cafa391b2.png)
