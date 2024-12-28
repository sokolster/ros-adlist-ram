:local cacheSize 32768
:local adlistUrl "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/light.txt"
:local tempFile "light.txt"
:local downloadComplete false

# Set DNS cache size
:if ([/ip/dns/get cache-size] < $cacheSize) do={
    /ip/dns/set cache-size=$cacheSize
}

# Flush current DNS cache and adlists
:local maxUptime 10m
:local uptime [/system resource get uptime]
:if ($uptime > $maxUptime) do={
    :log info "Uptime is more than 1 minute. Flushing DNS cache."
    /ip/dns/cache/flush
}
/ip/dns/adlist remove [find]

# Fetch the adlist
do {/tool fetch url=("$adlistUrl") output=file dst-path=$tempFile
    delay 2s
} on-error={
    :log error "File download failed or took too long."
    :error "Download failed. Exiting script."
}

:if ([/file find name=$tempFile] = "") do={
    :log error "File download failed."
    :error "Exiting due to missing file."
    #:delay 5s
}

#:log info "Adding adlist from $tempFile"
/ip/dns/adlist/add file=$tempFile 

/file remove $tempFile
:log info "Adlist update completed."
