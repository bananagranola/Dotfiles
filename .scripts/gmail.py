#!/usr/bin/env python2

#========================================================================
#      Copyright 2007 Raja <rajajs@gmail.com>
#
#      This program is free software; you can redistribute it and/or modify
#      it under the terms of the GNU General Public License as published by
#      the Free Software Foundation; either version 2 of the License, or
#      (at your option) any later version.
#
#      This program is distributed in the hope that it will be useful,
#      but WITHOUT ANY WARRANTY; without even the implied warranty of
#      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#      GNU General Public License for more details.
#
#      You should have received a copy of the GNU General Public License
#      along with this program; if not, write to the Free Software
#      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#==========================================================================

# ======================================================================
# Modified from code originally written by Baishampayan Ghose
# Copyright (C) 2006 Baishampayan Ghose <b.ghose@ubuntu.com>
# ======================================================================


import urllib             
import feedparser         
import os

_url = "https://mail.google.com/gmail/feed/atom"

##################   Edit here      #######################

pwd = 'XXXX'                                # pwd stored in script
_pwdfile = '/home/amytcheng/.scripts/googlepass.txt'  # pwd stored in a file
_username = 'amezster'

###########################################################

class GmailRSSOpener(urllib.FancyURLopener):
    '''Logs on with stored password and username
       Password is stored in a hidden file in the home folder'''
    
    def prompt_user_passwd(self, host, realm):
        #uncomment line below if password directly entered in script.
        pwd = open(_pwdfile).read().strip()
        return (_username, pwd)

def auth():
    '''The method to do HTTPBasicAuthentication'''
    opener = GmailRSSOpener()
    f = opener.open(_url)
    feed = f.read()
    return feed

def showmail(feed):
    '''Parse the Atom feed and print a summary'''
    atom = feedparser.parse(feed)
    mail = len(atom.entries)
    if (mail > 0):
        cmd= "/usr/bin/notify-send 'GMail:' '" + str( mail ) + " unread mail(s)'"
        os.system(cmd)

if __name__ == "__main__":
    feed = auth()  
    showmail(feed)
