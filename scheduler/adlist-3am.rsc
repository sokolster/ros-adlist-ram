:local scriptName "adlist-update"
:local uptimeThreshold 12h

:if ([/system resource get uptime] > $uptimeThreshold) do={
    /system script run $scriptName
}
