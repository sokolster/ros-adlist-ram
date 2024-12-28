:local scriptName "update-adlist"
:local uptimeThreshold 12h
:local currentUptime [/system resource get uptime]

:if ($currentUptime > $uptimeThreshold) do={
    /system script run $scriptName
}
