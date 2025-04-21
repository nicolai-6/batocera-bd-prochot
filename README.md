# batocera-bd-prochot

## Providing a tiny msr-tools wrapper script to disable bd-prochot on Intel CPUs

### facts
* only supported on specific Intel CPUs - consult your CPU specs and make sure you are suffering from bd-prochot issues (which can be caused by a lot of reasons) - this was tested on an Intel Core I7 9700T CPU
* can be run from batocera terminal, SSH or via emulationstation ports section
* only tested on batocera v41
* limited to x86_x64 platform
* shipping x86_x64 msr-tools (rdmsr, wrmsr) version 1.3
* Disabling bd-prochot is not permanent and will be reverted with every reboot - you have to rerun the ports BD-Prochot app everytime you boot batocera
* DO NOT run this multiple times in a row unless you know what you are doing - With every run, the value in the CPU register will be decreased

### Install
* make sure your internet connection is working
* run two terminal commands from batocera (F1->applications->xterm) or via SSH to install it

    ```
    curl -o /tmp/install.sh https://raw.githubusercontent.com/nicolai-6/batocera-bd-prochot/refs/heads/main/install.sh
    bash /tmp/install.sh
    ```

### run it
* update batocera gamelists (GAME SETTINGS > UPDATE GAMELISTS)
* Run from Emulationstation:
    * navigate to PORTS and run ``` BD-Prochot ```
* Run from terminal:
    * /userdata/roms/ports/bd_prochot_runner.sh

### appendix
* Manual cleanup via terminal
    * remove /userdata/roms/ports/bd_prochot.sh
    * remove /userdata/roms/ports/.data/bd_prochot directory
    * remove from Ports gamelist either via emulationstation or gamelist.xml

### disabling bd prochot in batocera without installing this app
* copy rdmsr and wrmsr to your batocera instance
* make it executable `chmod +x rdmsr && chmod +x wrmsr`
* activate msr module by running `modprobe msr`
* read value of register address 0x1FC `rdmsr -a -d 0x1FC` -> returns a value (multiple times if multicore CPU)
* substract 1 of the returned value and write it to the register
`wrmsr 0x1F returnedValue-1`

### troubleshooting / debugging
* Watch your CPU clock speeds BEFORE and AFTER disabling BD-Prochot while stresstest or "heavy" gaming
    
    `watch "(cat /proc/cpuinfo | grep "MHz")"`

### be careful if you disable bd-prochot and make sure your CPU temps are still fine
* Do some "heavy" gaming and verify CPU temps with this command
    
    `while true; do echo $(date); cat /sys/class/thermal/thermal_zone*/temp | awk '{ print ($1 / 1000) "°C" }'; sleep 3; done`
