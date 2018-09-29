import serial
import time
 
fd=serial.Serial("COM3",9600)


print('COM3')
time.sleep(1)
#fd.write('P')

print('50')
fd.write('\x50'.encode())
#fd.write('P'.encode())
time.sleep(1)

answer=fd.read(1)
print(answer)
#fd.write('P'.encode())
time.sleep(1)

print('51')
fd.write('\x51'.encode())
#fd.write('Q'.encode()) 


time.sleep(1)
print('00 - Off Off')
fd.write('\x00'.encode())


time.sleep(1)
print('03 - On On')
fd.write('\x03'.encode())

time.sleep(1)
print('02 - Off On')
fd.write('\x02'.encode())

time.sleep(1)
print('01 - On Off')
fd.write('\x01'.encode())


time.sleep(1)
print('03 - On On')
fd.write('\x03'.encode())

time.sleep(1)
print('00 - Off Off')
fd.write('\x00'.encode())

fd.close()