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
from optparse import OptionParser

_url = "https://mail.google.com/gmail/feed/atom"

##################   Edit here      #######################

pwd = 'XXXX'                                # pwd stored in script
_pwdfile = '/home/amytcheng/.scripts/pass.txt'  # pwd stored in a file
_username = 'amezster'
_maxmails = 5  # maximum new mails to show
_maxwords = 3  # maximum words to show in each mail header

###########################################################

class GmailRSSOpener(urllib.FancyURLopener):
    '''Logs on with stored password and username
       Password is stored in a hidden file in the home folder'''
    
    def prompt_user_passwd(self, host, realm):
        #uncomment line below if password directly entered in script.
        pwd = open(_pwdfile).read().strip()
        return (_username, pwd)

def getOptions(parser):
    parser.add_option("-c", "--count", action="store_true",dest="count", default=None,
                      help="count")
    parser.add_option("-m", "--mails", action="store_true",dest="mails", default=None,
                      help="mails")
    options, args = parser.parse_args()

    return options.count, options.mails

def auth():
    '''The method to do HTTPBasicAuthentication'''
    opener = GmailRSSOpener()
    f = opener.open(_url)
    feed = f.read()
    return feed

def showmail(feed, count, mails):
    '''Parse the Atom feed and print a summary'''
    atom = feedparser.parse(feed)
    newmails = len(atom.entries)

    if mails:
        for i in range(min(_maxmails,newmails)):
        
            emailtitle = atom.entries[i].title
            if len(emailtitle.split()) > _maxwords:
                emailtitle = ' '.join(emailtitle.split()[:_maxwords])
            
            print "%s from %s" % (emailtitle, atom.entries[i].author)
    else:
        print "%s" % (newmails)

if __name__ == "__main__":
    parser = OptionParser()
    count, mails = getOptions(parser)
    feed = auth()  
    showmail(feed, count, mails)
