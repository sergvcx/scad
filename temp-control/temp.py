import serial
import time
import os 
files = os.listdir(".") 
logfile=files[0]
print(files[0])

#logs = filter(lambda x: x.endswith('.txt'), files) 
#for d in logs:
#	print (d)
#exit()
 
fd=serial.Serial("COM3",9600,timeout=3)

print('50')
fd.write('\x50'.encode())
time.sleep(1)

answer=fd.read(1)
print(answer)
if answer==b'':
	print('relay already  inited')
if answer==b'\xab':
	print('51')
	fd.write('\x51'.encode())

time.sleep(1)
print('00')
fd.write('\x00'.encode())

time.sleep(1)
print('03')
fd.write('\x03'.encode())
time.sleep(1)	

print('START!')

hum_max = 33.00
hum_min = 30.00 

water     = False

#http://help.ubuntu.ru/fullcircle/29/python_%D1%87_3
loop=0

while 1:
	#f = open('d:\\GIT\\Python\\2017-11-7 2h58m29s.txt')
	f = open(logfile)
	n = 9 
	for i, line in enumerate(f):
		line = line.replace("\n", "")
	
	words=line.split(',')
	if len(words)<8:
		print(len(words))
		f.close()
		time.sleep(10)
		continue
		
	temp=words[1].replace(' ','')+'.'+words[2].replace(' ','')
	hum =words[3].replace(' ','')+'.'+words[4].replace(' ','')
	dew =words[5].replace(' ','')+'.'+words[6].replace(' ','')
	when=words[7]
	print(when+ ' '+temp+'C '+hum+'%')
	
	if water:
		if float(hum)>hum_max:
			print('water off')
			water=False
			fd.write('\x03'.encode())
	else:
		if float(hum)<hum_min:
			print('water on')
			water=True
			fd.write('\x00'.encode())
			
	loop = loop +1
	time.sleep(10)
	f.close()
	
print('****')
print(line)