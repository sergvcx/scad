#import serial
import time
 
#fd=serial.Serial("COM4",9600)



#http://help.ubuntu.ru/fullcircle/29/python_%D1%87_3
loop =0
while loop <=100:
	f = open('d:\\GIT\\Python\\2017-5-16 11h33m15s.txt')
	n = 9 
	for i, line in enumerate(f):
		line = line.replace("\n", "")
	#if i >= n:
	#	print(line)
	#print(loop)
	print(line)
	#line=line.replace(' ','')
	words=line.split(',')
	for j in words:
		print(j)
	temp=words[1].replace(' ','')+'.'+words[2].replace(' ','')
	hum =words[3].replace(' ','')+'.'+words[4].replace(' ','')
	dew =words[5].replace(' ','')+'.'+words[6].replace(' ','')
	#when=words[7]
	
	print('hum='+hum)
	print('temp='+temp)
	print('dew='+dew)
	#print('when='+when)
	loop = loop +1
	
	time.sleep(1)
	
	f.close()
	
print('****')
print(line)