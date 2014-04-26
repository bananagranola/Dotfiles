#!/usr/bin/python
# Reddit Ravelry Bot
# by u/bananagranola

import sys
import signal
import praw
import pprint
import re
import urllib2
import base64
try: import simplejson as json
except ImportError: import json

ravelry = "http://www.ravelry.com/"
pattern_match = "patterns/library/"
project_match = "projects/"
yarn_match = "yarns/library/"
people_match = "people/"
designer_match = "designers/"
yarn_company_match = "yarns/brands/"
pat_match_len = len(pattern_match)
proj_match_len = len(project_match)
yarn_match_len = len(yarn_match)
default = "-"

ravelry_api = "https://api.ravelry.com/"
pattern_api = ravelry_api + "patterns/{}.json"
project_api = ravelry_api + "projects/{}.json"
yarn_api = ravelry_api + "yarns/{}.json"

def signal_handler(signal, frame):
	sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

def requesting(url):
	accesskey = sys.argv[1]
	personalkey = sys.argv[2]
	request = urllib2.Request(url)
	base64string = base64.encodestring('%s:%s' % (accesskey, personalkey)).replace('\n', '')
	request.add_header("Authorization", "Basic %s" % base64string)   
	requested = urllib2.urlopen(request)
	return json.load(requested)

def formatpattern(match):
	index = match.index(pattern_match)
	url = pattern_api.format(match[index+pat_match_len:])
	data = requesting(url)
	pattern = data.get('pattern',default)
	
	name = pattern.get('name',default)
	permalink = pattern.get('permalink',default)
	permalink = ravelry + pattern_match + permalink
	pattern_author = pattern.get('pattern_author',default)
	pattern_author_name = pattern_author.get('name', default)
	pattern_author_permalink = pattern_author.get('permalink', default)
	pattern_author_permalink = ravelry + designer_match + pattern_author_permalink
	comment = u"**PATTERN: [{}]({}) by [{}]({})**\n\n".format(name,permalink,pattern_author_name,pattern_author_permalink).encode('utf-8')

	yarn_weight = pattern.get('yarn_weight', default)
	if yarn_weight != default:
		yarn_weight = yarn_weight.get('name', default)
	gauge = pattern.get('gauge',default)
	yardage = pattern.get('yardage',default)
	comment = comment + u"* Yarn Weight: {} | Gauge: {} | Yardage: {}\n\n".format(yarn_weight,gauge,yardage).encode('utf-8')
	
	free = pattern.get('free',default)
	comment = comment + u"* Free: {}".format(free).encode('utf-8')
	if free == False:
		price = pattern.get('price',default)
		currency = pattern.get('currency',default)
		comment = comment + u" | Price: {} {}\n\n".format(price, currency).encode('utf-8')
	else:
		comment = comment + "\n\n".encode('utf-8')
	
	difficulty_average = pattern.get('difficulty_average',default)
	favorites_count = pattern.get('favorites_count',default)
	projects_count = pattern.get('projects_count',default)
	queued_projects_count = pattern.get('queued_projects_count',default)
	rating_average = pattern.get('rating_average',default)
	comment = comment + u"* Dif.: {:.1f}/5 | Fav.: {} | Proj.: {} | Qu.: {} | Rat: {:.1f}/5\n\n".format(difficulty_average, favorites_count, projects_count, queued_projects_count, rating_average).encode('utf-8')
	
	return comment

def formatproject(match):
	#pprint.pprint (data)
	index = match.index(project_match)
	url = project_api.format(match[index+proj_match_len:])
	data = requesting(url)
	project = data.get('project',default)
	
	name = project.get('name',default)
	id = project.get('id',default)
	permalink = project.get('permalink',default)
	user = project.get('user',default)
	username = user.get('username', default)
	permalink = ravelry + project_match + "{}/{}".format(username,id)
	user_permalink = ravelry + people_match + str(username)
	comment =  u"**PROJECT: [{}]({}) by [{}]({})**\n\n".format(name,permalink,username,user_permalink).encode('utf-8')

	pattern_name = project.get('pattern_name', default)
	if pattern_name is not None and pattern_name != default:
		pattern_id = project.get('pattern_id', default)
		if pattern_id is not None and pattern_id != default:
			pattern_json = pattern_api.format(pattern_id)
			pattern_request = requesting(pattern_json)
			pattern = pattern_request.get('pattern',default)
			pattern_permalink = pattern.get('permalink',default)
			pattern_permalink = ravelry + pattern_match + pattern_permalink
			comment = comment + u"* Pattern: [{}]({})\n\n".format(pattern_name, pattern_permalink).encode('utf-8')
		else:
			comment = comment + u"* Pattern: {}\n\n".format(pattern_name).encode('utf-8')
	
	pack = project.get('pack', default)
	if pack is not None and pack != default:
		yarn_name = pack.get('yarn_name', default)
		yarn_weight = pack.get('yarn_weight', default)
		yarn_id = pack.get('yarn_id', default)
		yarn_json = yarn_api.format(yarn_id)
		yarn_request = requesting(yarn_json)
		yarn = yarn_request.get('yarn',default)
		yarn_permalink = yarn.get('permalink',default)
		yarn_permalink = ravelry + yarn_match + yarn_permalink
		comment = comment + u"* Yarn: [{}]({})\n\n".format(yarn_name, yarn_permalink).encode('utf-8')
	
	progress = project.get('progress', default)
	started = project.get('started', default)
	completed = project.get('completed', default)
	comment = comment + u"* Started: {} | Completed: {}\n\n".format(started, completed).encode('utf-8')
	
	return comment

def formatyarn(match):
	#pprint.pprint(data)
	index = match.index(yarn_match)
	url = yarn_api.format(match[index+yarn_match_len:])
	data = requesting(url)
	yarn = data.get('yarn',default)

	name = yarn.get('name',default)
	permalink = yarn.get('permalink',default)
	permalink = ravelry + yarn_match + permalink

	yarn_company = yarn.get('yarn_company', default)
	yarn_company_id = yarn_company.get('id', default)
	if yarn_company_id != default:
		yarn_company_name = yarn_company.get('name', default)
		yarn_company_permalink = yarn_company.get('permalink', default)
		yarn_company_permalink = ravelry + yarn_company_match + yarn_company_permalink
		comment = u"**YARN: [{}]({}) by [{}]({})**\n\n".format(name,permalink,yarn_company_name,yarn_company_permalink).encode('utf-8')
	else:
		comment = u"**YARN: [{}]({})**\n\n".format(name,permalink).encode('utf-8')

	yarn_weight = yarn.get('yarn_weight',default)
	yarn_weight_name = yarn_weight.get('name', default)
	grams = yarn.get('grams',default)
	yarn_fibers = yarn.get('yarn_fibers',default)
	yardage = yarn.get('yardage',default)
	machine_washable = yarn.get('machine_washable',default)
	
	yarn_fibers = yarn.get('yarn_fibers',default)
	fibers = ""
	for yarn_fiber in yarn_fibers:
		fiber_type = yarn_fiber.get('fiber_type',default)
		fibers = fibers + fiber_type.get('name',default) + " "
	comment = comment + u"* Yarn Weight: {} | Grams: {} | Yardage: {} | Fibers: {}| Machine Washable: {}\n\n".format(yarn_weight_name, grams, yardage, fibers, machine_washable).encode('utf-8')

	rating_average = yarn.get('rating_average',default)
	rating_count = yarn.get('rating_count',default)
	comment = comment + u"* Rating: {:.1f}/5 | Ratings: {}\n\n".format(rating_average, rating_count).encode('utf-8')

	return comment

reddit = praw.Reddit('redravbot by u/bananagranola')
subreddit = reddit.get_subreddit('knitting')

commented_file = open('commented.txt', 'r')
commented = set(line.strip() for line in commented_file)
commented_file.close()

for submission in subreddit.get_new(limit = 25):

	flat_comments = praw.helpers.flatten_tree(submission.comments)
	print ("SUBMISSION ID: {}".format(submission.id))
	
	for comment in flat_comments:
		if "ravelry.com" in comment.body and comment.id not in commented and "search" not in comment.body:
			matches = re.findall('\(([^)]+rav[^)]+)\)', comment.body, flags=0)
			print ("COMMENT ID: {}".format(comment.id))
			
			comment_reply = ""
			for match in matches:
				
				if re.match('.*/patterns/library/.*', match, flags=0):
					comment_reply = comment_reply + formatpattern(match)
				
				elif re.match('.*/projects/.*', match, flags=0):
					comment_reply = comment_reply + formatproject(match)
				
				elif re.match('.*/yarns/library/.*', match, flags=0):
					comment_reply = comment_reply + formatyarn(match)

			# post the comment 
			#comment.reply ('')
			print comment_reply
			commented.add(comment.id)
			
			# record commented status
			commented_file = open('commented.txt', 'a')
			commented_file.write(comment.id)
			commented_file.write("\n")
			commented_file.close()

