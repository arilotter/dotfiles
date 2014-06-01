#!/usr/bin/python

import urllib2
import os
import json

URL = 'http://hastebin.com/documents'

def run(*args):
    if args:
        content = [open(x).read() for x in args]
        extensions = [os.path.splitext(x)[1] for x in args]
    else:
        content = [sys.stdin.read()]
        extensions = [None]

    for i, each in enumerate(content):
        req = urllib2.Request(URL, each)
        response = urllib2.urlopen(req)
        the_page = response.read()
        key = json.loads(the_page)['key']
        url = "http://hastebin.com/%s" % key
        if extensions[i]:
            url += extensions[i]
        print url

if __name__ == '__main__':
    import sys
    sys.exit(run(*sys.argv[1:]))
