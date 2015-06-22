#!/bin/sh

VALUE=`cat /proc/cpuinfo | grep -m1 cores`

nVal=`expr ${VALUE:11}`


echo $nVal
