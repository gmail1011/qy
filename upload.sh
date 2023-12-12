#!/bin/sh
scp  $1  server@192.168.1.9:/home/server/apk/dsp
ssh server@192.168.1.9  "bash /home/server/apk/dsp/dsp.sh"
