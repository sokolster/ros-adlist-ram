# MikroTik RouterOS Adlist in RAM for Low-Memory Routers

This guide helps you manage adlists in RAM on MikroTik routers with limited memory, such as the hAP ac². The scripts download, process, and apply adlists while ensuring minimal memory usage.

## Features
- **Adlists stored in RAM**: Prevents writing to flash memory to extend its lifespan.
- **Scheduled updates**: Automatically refresh adlists daily and on startup.
- **Optimized for low memory**: Works even on routers with constrained resources.

---

## Files
1. **`adlist-update.rsc`**  
   Downloads and updates the adlist in RAM.

2. **`adlist-3am.rsc`**  
   Schedules daily adlist updates at 3:00 AM every 2 days.

3. **`adlist-boot.rsc`**  
   Ensures adlists are loaded on boot.

---

## Installation

### 1. Upload Scripts to the Router
Download the scripts from GitHub to your MikroTik router using `/tool fetch`.

```shell
/tool fetch url="https://raw.githubusercontent.com/sokolster/ros-adlist-ram/refs/heads/main/scripts/adlist-update.rsc"
/tool fetch url="https://raw.githubusercontent.com/sokolster/ros-adlist-ram/refs/heads/main/scheduler/adlist-3am.rsc"
/tool fetch url="https://raw.githubusercontent.com/sokolster/ros-adlist-ram/refs/heads/main/scheduler/adlist-boot.rsc"
```

### 2. Add Scripts to the Router
   
```shell
/system script add name=adlist-update policy=ftp,read,write,test source=[/file get adlist-update.rsc contents]
/system scheduler add name="adlist-3am"policy=ftp,read,write,test start-time=03:00 interval=2d on-event="/import file-name=adlist-3am.rsc"
/system scheduler add name="adlist-boot" policy=ftp,read,write,test start-time=startup on-event="/import file-name=adlist-boot.rsc"

/file remove [find name~"adlist-.*\\.rsc"]
```

###3. Verify Setup

reboot and check

```shell
/ip/dns/print
/ip/dns/adlist/print
```
## Notes

- This setup works on **hAP ac²** routers with 128mb ram.
- Setting `cacheSize` to `32768` allows the use of up to **197k DNS entries**.
- feature was added in **RouterOS 7.15+**

## Thanks To
- **[hagezi/dns-blocklists](https://github.com/hagezi/dns-blocklists)**  
  For providing valuable DNS blocklists that can be used in this setup.

- **[MikroTik Forum - Thread on Adlists](https://forum.mikrotik.com/viewtopic.php?t=209239)**  
  For contributing to the community discussion on using adlists on MikroTik routers.
