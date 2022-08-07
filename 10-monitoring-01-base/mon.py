#!/usr/bin/env python3
import os
import datetime
import json

Today = datetime.date.today()
Years = str(Today.year)[2:]
dt_now = datetime.datetime.now()


def file_open_write (name):
    filename = f'{Years}-{Today.month}-{Today.month}-awesome-monitoring.log'
    filepath = '/var/log/' + filename
    if os.path.isfile(filepath) == False:
        delfile = open(filepath, 'w')
        delfile.close()
    fileLog = open(filepath, 'a')
    jsonfile = {str(dt_now): name}
    json.dump(jsonfile, fileLog, indent=2)
    fileLog.close()
    return

listjson = {}

#Средняя загрузка
loadavg = open('/proc/loadavg', 'r')
loadavgdict = loadavg.read().split(' ')
loadavgdict = loadavgdict[:3]
loadavg = ['avg-1min', 'avg-5min', 'avg-15min']
listjson = dict(zip(loadavg, loadavgdict))

#температура
tempproc = open('/sys/class/hwmon/hwmon0/device/hwmon0/device/hwmon0/temp1_input', 'r')
tempproc = tempproc.read()
tempproc = tempproc[:2]
listjson['temperature'] = tempproc

#Время работы 
uptime = open('/proc/uptime', 'r') 
uptime = uptime.read().split(' ')
uptime = int(float(uptime[0]) / 60)
listjson['uptime-min'] = uptime

#RAM
meminfo = open('/proc/meminfo','r')
meminfo = meminfo.read().split('\n')
MemTotal = meminfo[0].split(' ')
MemAvailable = meminfo[2].split(' ')
Memfreeprocent = int(int(MemAvailable[-2]) / int(MemTotal[-2]) * 100)
listjson['memfree %'] = Memfreeprocent

file_open_write(listjson)
