#!/usr/bin/python2

import os
import subprocess

def bash_command(cmd):
	subprocess.Popen(cmd,shell=True,executable='/bin/bash')
#subprocess.Popen(['/bin/bash','-c',cmd])

com="wget -q -O - biowarestore.com/art/lithographs.html?limit=all"

temp=os.popen(com)
msg=temp.read()

beg=0
end=10000000000
fc=''
beglist=[(0)]
endlist=[(0)]

while True:
    beg=msg.find("title=\"ME",end+10)+7
   
    try:
        beglist.index(beg)
        break
    except ValueError:
        beglist.append(beg)

    end=msg.find("\"",beg)
    endlist.append(end)
    
    if beg != 6:
        fc+=msg[beg:end]
        fc+="\n"

f=open("/home/amytcheng/.scripts/lith.txt",'r')
fmsg=f.read()
if fmsg != fc:
    f=open("/home/amytcheng/.scripts/lith.txt",'w')
    f.write(str(fc))
    bash_command('notify-send "lithographs modified."')
    print(True)

