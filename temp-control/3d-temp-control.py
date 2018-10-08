import serial
import time
import os 
files = os.listdir(".") 
#logfile=files[0]
logfile="TEMPerX1.txt"
print(files[0])

#logs = filter(lambda x: x.endswith('.txt'), files) 
#for d in logs:
#	print (d)
#exit()
 

# pySerial can be installed from PyPI:

#python -m pip install pyserial

fd=serial.Serial("COM10",9600,timeout=3)

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

temp_max = 40.00
temp_min = 39.00 

heat     = False

#http://help.ubuntu.ru/fullcircle/29/python_%D1%87_3
loop=0

while 1:
	#f = open('d:\\GIT\\Python\\2017-11-7 2h58m29s.txt')
	f = open(logfile)
	n = 9 
	for i, line in enumerate(f):
		line = line.replace("\n", "")
	
	words=line.split(' ')
	print (line)
	print (len(words))
	
	if len(words)<2:
		print(len(words))
		f.close()
		time.sleep(10)
		continue
	print (words[0] + '=' + words[1]);
	
	date=words[0];
	
	words = words[1].split(',')
	timer = words[0];
	temp = words[1];
	tempfrac= words[2];
	print ("date:"+date +' time:'+ timer +" temp:" +temp+"."+tempfrac  );
	#temp=words[1].replace(' ','')+'.'+words[2].replace(' ','')
	#hum =words[3].replace(' ','')+'.'+words[4].replace(' ','')
	#dew =words[5].replace(' ','')+'.'+words[6].replace(' ','')
	#when=words[7]
	#print(when+ ' '+temp+'C '+hum+'%')
	
	if heat:
		if float(temp)>=temp_max:
			print('heating off')
			heat=False
			fd.write('\x03'.encode())
	else:
		if float(temp)<=temp_min:
			print('heating on')
			heat=True
			fd.write('\x00'.encode())
			
	loop = loop +1
	time.sleep(10)
	f.close()
	
print('****')
print(line)