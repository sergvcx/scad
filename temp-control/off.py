import serial
import time
 
fd=serial.Serial("COM3",9600)


time.sleep(1)
print('03')
fd.write('\x03'.encode())

