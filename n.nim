import ipAdresses
import asyncdispatch
import asyncnet
import net

proc mycheck(ip: string, port: int): Future[void] {.async.} =
  var socket = newAsyncSocket()
  var hasTimeouted =  await withTimeout (socket.connect(ip, Port(port)) , 2500)

  if hasTimeouted:
    echo "--> ", ip, " open!"
  else:
    echo ip, " closed!"
    socket.close()

for myip in ips("192.168.2.1-10,12-100,101,100-254"):
  # echo "scan ", myip
  asyncCheck mycheck($myip, 22)

runForever()  