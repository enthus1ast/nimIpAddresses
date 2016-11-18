#
#
#            (Nim's Runtime Library)
#        (c) Copyright 2016 David Krause
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#
## This file implements procedures to parse the Nmap address syntax
## .. code-block::
##  192.168.1,2.10-20,100-200
## use iterator `ips` to iterate all ips in the expandet range

import net
import strutils
import parseutils
import sequtils
import macros

iterator buildIpAddressV4(se: seq[seq[string]]): IpAddress =
  ## build sequenze of IpAddress out of eg @[@[10], @[1, 2, 3], @[0], @[4, 5, 6]]
  # TODO this is stupid
  # TODO maybe macro can solve this...
  var buf: string = ""
  if se.len == 4:
    for one in se[0]:
      for two in se[1]:
        for three in se[2]:
          for four in se[3]:
            yield parseIpAddress("$1.$2.$3.$4" % [one,two,three,four] )

iterator buildIpAddressV6(se: seq[seq[string]]): IpAddress =
  ## build sequenze of IpAddress out of @[@[10], @[1, 2, 3], @[0], @[4, 5, 6]]
  discard
  echo "ipv6 not implemented yet"
  # var buf: string = ""
  # if se.len == 4:
  #   for one in se[0]:
  #     for two in se[1]:
  #       for three in se[2]:
  #         for four in se[3]:
  #           yield parseIpAddress("$1.$2.$3.$4" % [one,two,three,four] )
  discard

proc expandV4(ips: string): seq[seq[string]] =  
  var octets: seq[seq[string]] = @[]
  for octet in ips.split("."):
    if not (',' in octet) and not ('-' in octet):
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
  return octets

proc expandV6(ips: string): seq[seq[string]] =  
  discard

iterator ips*(ipStr: string): IpAddress = 
  ## this parses a string like this "192.168.1,2.10-100"
  ## and yields an IpAddress for every ip in the range.
  var ranges: seq[seq[string]]
  if ipStr.contains(':'):
    # ipv6
    ranges = expandV6(ipStr)
    for ip in buildIpAddressV6(ranges):
      yield ip
  else:
    # ipv4
    ranges = expandV4(ipStr)
    for ip in buildIpAddressV4(ranges):
      yield ip

when isMainModule:
  for ip in ips("192.168.1,2.1-10"):
   echo ip

# when isMainModule:
  # assert buildIpAddresses(nmapIp("10.0.0.1,2,3")) == @[parseIpAddress "10.0.0.1", parseIpAddress "10.0.0.2", parseIpAddress "10.0.0.3"]
  # assert ip("10.0.0.1,2,4-6") == @[ parseIpAddress "10.0.0.1",  parseIpAddress "10.0.0.2",  parseIpAddress "10.0.0.4",  parseIpAddress "10.0.0.5",  parseIpAddress "10.0.0.6"]
  # assert ip("10.0.0.3-6") == @["10.0.0.3", "10.0.0.4", "10.0.0.5", "10.0.0.6"]
  # assert ip("10.0.1-2.1-3") == @["10.0.1.1", "10.0.1.2", "10.0.1.3", "10.0.2.1", "10.0.2.2", "10.0.2.3",]
  #assert ip("10.0.0.0/24") == @["10.0.0.1", "10.0.0.2", "10.0.0.4", "10.0.0.5", "10.0.0.6"]
