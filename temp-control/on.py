import serial
import time
 
fd=serial.Serial("COM3",9600)


time.sleep(1)
print('01')
fd.write('\x01'.encode())

