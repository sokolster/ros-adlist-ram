:local scriptName "adlist-update"
:local sdelay 20

:log info "Startup: Waiting $sdelay seconds..."
:delay ($sdelay . "s")

# Check internet connectivity
:local internetUp false
:local retries 0
:local maxRetries 10
:local retryInterval 10
:while (($retries < $maxRetries) && (!$internetUp)) do={
    :set retries ($retries + 1)
    :log info "Checking internet connectivity (attempt $retries)..."

    # Test connectivity (e.g., ping Google's public DNS)
    :if ([/ping 8.8.8.8 count=2] > 0) do={
        :log info "Internet is up!"
        :set internetUp true
    } else={
        :log warning "Internet is still down. Retrying in $retryInterval seconds..."
        :delay ($retryInterval . "s")
    }
}

# Check if the internet is up
:if (!$internetUp) do={
    :error "Internet is unavailable. Script terminated."
}

:log info "Running script: $scriptName"
/system script run $scriptName
