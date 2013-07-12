#!/usr/bin/python
import json
import urllib2
import os

class request:
	pass

class ttrss:
	session_id = ''
	def __init__(self, url):
		self.baseurl = url

	def getResponse(self, call):
		call['sid'] = self.session_id
		httpres = urllib2.urlopen(self.baseurl, json.dumps(call))
		ttrssresponse = json.load(httpres)
		return ttrssresponse
	
	def login(self, username, password):
		req = { 'op': 'login', 'user': username, 'password':password }
		res = self.getResponse(req)
		self.session_id = res['content']['session_id']

	def getUnreadCount(self):
		req = { 'op': 'getUnread'}
		res = self.getResponse(req)
		return int( res['content']['unread'] )

# TT-RSS API URL
t = ttrss('https://whereami.redirectme.net/tt-rss/api/')
# Username, password
t.login('bananagranola','a1m2y3')
unread = t.getUnreadCount()
if (unread > 0):
	cmd = "/usr/bin/notify-send 'Tiny Tiny RSS:' '" + str( unread ) + " unread article(s)'"
	os.system( cmd )
