#!/bin/bash
# in　test 

case $1 in
redhat|RedHat|REDHAT)
	echo fedora;;
fedora|Fedora|FEDORA)
	echo redhat;;
*)
	echo 正确用法 testcase  redhat/fedora
esac
