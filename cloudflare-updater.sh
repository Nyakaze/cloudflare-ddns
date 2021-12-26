#!/bin/bash
## change to "bin/sh" when necessary

auth_email=""                                   # The email used to login 'https://dash.cloudflare.com'
auth_method="global"                            # Set to "global" for Global API Key or "token" for Scoped API Token 
auth_key=""                                     # Your API Token or Global API Key
zone_identifier=""                              # Can be found in the "Overview" tab of your domain
record_name=()                                  # Which records should be updated
                                                # should look like this
                                                # record_name=("firstDomain" "secondDomain" "thirdDomain")
ttl="3600"                                      # Set the DNS TTL (seconds)
proxy=true                                      # Set the proxy to true or false
discord_success_noti=false                      # Send Success notification true or false
discord_failed_noti=false                       # Send Failed notification true or false
discord_nothing_changed_noti=false              # Send Nothing changed notification true or false
webhook_url=""                                  # Set the Webhook URL you created
bot_name=""                                     # Set the Name of the Bot


###########################################
## Check if public IP is available
###########################################
ip=$(curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com/)

if [ "${ip}" == "" ]; then 
    echo "WARNING: Public IP not found"
    exit 1
fi

###########################################
## Set proper auth header
###########################################
if [ "${auth_method}" == "global" ]; then
    auth_header="X-Auth-Key:"
else
    auth_header="Authorization: Bearer"
fi

###########################################
## Update all records
###########################################

for item in ${record_name[*]}
do
    echo "ITEM: $item"
    #Get itemrecord from API
    item_record=($(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?type=A&name=$item" \
                    -H "X-Auth-Email: $auth_email" \
                    -H "$auth_header $auth_key" \
                    -H "Content-Type: application/json"))

    #Check if record has content
    if grep -q "content" <<< "$item_record"
    then
        item_ip=$(echo "$item_record" | sed -E 's/.*"content":"(([0-9]{1,3}\.){3}[0-9]{1,3})".*/\1/')
        echo "ITEM IP: $item_ip"

        #Check if old IP is different from current IP
        if [[ ${item_ip} != ${ip} ]]
        then
            #Set the record identifier from result
            record_identifier=($(echo "$item_record" | (sed -E 's/.*"id":"(\w+)".*/\1/')))
            update=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
                    -H "X-Auth-Email: $auth_email" \
                    -H "$auth_header $auth_key" \
                    -H "Content-Type: application/json" \
            --data "{\"type\":\"A\",\"name\":\"$item\",\"content\":\"$ip\",\"ttl\":\"$ttl\",\"proxied\":${proxy}}")
            
            #Check if Update was successful
            if grep -q "\"success\":true" <<< "$update"
            then
                if $discord_success_noti
                then
                    _result=$(curl -H "Content-Type: application/json" -H "Expect: application/json" -X POST "${webhook_url}" -d "{\"username\": \"$bot_name\", \"embeds\": [{\"title\":\"Successfully updated\", \"description\":\"Successfully updated $item to $ip\", \"color\": \"11731199\", \"footer\":{\"text\":\"Made by Makaze | $(date +%d/%m/%Y-%H:%M:%S)\", \"icon_url\":\"https://cdn.discordapp.com/avatars/232969409709211648/a_1775ffc92881da3a12cd2dc9055e173b.png\"}}]}" 2>/dev/null)
                fi
                echo "Changed!"
            else
                if $discord_failed_noti
                then
                    _result=$(curl -H "Content-Type: application/json" -H "Expect: application/json" -X POST "${webhook_url}" -d "{\"username\": \"$bot_name\", \"embeds\": [{\"title\":\"Failed to update\", \"description\":\"Updating $item from $item_ip to $ip was not possible\", \"color\": \"11731199\", \"footer\":{\"text\":\"Made by Makaze | $(date +%d/%m/%Y-%H:%M:%S)\", \"icon_url\":\"https://cdn.discordapp.com/avatars/232969409709211648/a_1775ffc92881da3a12cd2dc9055e173b.png\"}}]}" 2>/dev/null)
                fi
                echo "Not Changed!"
            fi

        else
            echo "RECORD ALREADY HAS NEW IP!"
            if $discord_nothing_changed_noti
            then
                _result=$(curl -H "Content-Type: application/json" -H "Expect: application/json" -X POST "${webhook_url}" -d "{\"username\": \"$bot_name\", \"embeds\": [{\"title\":\"Nothing changed\", \"description\":\"$item had already the new IP\", \"color\": \"11731199\", \"footer\":{\"text\":\"Made by Makaze | $(date +%d/%m/%Y-%H:%M:%S)\", \"icon_url\":\"https://cdn.discordapp.com/avatars/232969409709211648/a_1775ffc92881da3a12cd2dc9055e173b.png\"}}]}" 2>/dev/null)
            fi
        fi
    else
        echo "RECORD DOES NOT EXIST!"
    fi
done