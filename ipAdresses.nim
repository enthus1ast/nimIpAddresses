import net
import strutils
import parseutils

proc buildIpAddresses(se: seq[seq[string]]): seq[IpAddress] =
  ## build sequenze of IpAddress out of @[@[10], @[1, 2, 3], @[0], @[4, 5, 6]]
  result = @[]
  var buf: string = ""
  for i, octet in se:
    for part in octet:




proc ip(ips: string): seq[IpAddress] = 
  var octets: seq[seq[string]] = @[]
  if ips.contains(':'):
    # ipv6
  #   # return parseIPv6Address(address_str)
    discard
  else:
  #   # ipv4
  #   # return parseIPv4Address(address_str)  
    for octet in ips.split("."):
      # octet = "10" , "1,3" , "1-9" , "1,3,5-9"
      # echo octet

      if not (',' in octet) and not ('-' in octet): # and "," not in octet:
        octets.add(@[octet])
      else:
        var buf: seq[string] = @[]
        for comSep in octet.split(","):
          if "-" in comSep:
            var rangeParts = comSep.split("-")
            for i in (parseInt rangeParts[0])..(parseInt rangeParts[1]):
              buf.add($i)       
          else:
            buf.add(comSep)
        octets.add(buf)
    echo octets



      # var comParts: seq[string] = @[]
      # for comSep in octet.split(","):
        # if '-' in comSep:
          
          # var rangeParts = octet.split("-")
          # var rangeOctet: seq[string] = @[]
          # for i in (parseInt rangeParts[0])..(parseInt rangeParts[1]):
            # rangeOctet.add($i)
          # octets.add(rangeOctet)
      # else:
        # octets.add(octet)
      # if not (',' in octet) and not ('-' in octet): # and "," not in octet:
        # octets.add(@[octet])
    # discard
  # echo octets

var a=1
var b=10
# echo a..b

# echo parseIpAddress("10.0.0.1")
# discard ip("10.0.0.1,2,4-6")
discard ip("10.1-3.0.4-6")

# when isMainModule:
  # assert ip("10.0.0.1,2,3") == @[parseIpAddress "10.0.0.1", parseIpAddress "10.0.0.2", parseIpAddress "10.0.0.3"]
  # assert ip("10.0.0.1,2,4-6") == @[ parseIpAddress "10.0.0.1",  parseIpAddress "10.0.0.2",  parseIpAddress "10.0.0.4",  parseIpAddress "10.0.0.5",  parseIpAddress "10.0.0.6"]
  # assert ip("10.0.0.3-6") == @["10.0.0.3", "10.0.0.4", "10.0.0.5", "10.0.0.6"]
  # assert ip("10.0.1-2.1-3") == @["10.0.1.1", "10.0.1.2", "10.0.1.3", "10.0.2.1", "10.0.2.2", "10.0.2.3",]
  #assert ip("10.0.0.0/24") == @["10.0.0.1", "10.0.0.2", "10.0.0.4", "10.0.0.5", "10.0.0.6"]

