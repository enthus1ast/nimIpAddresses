#
#
#        (c) Copyright 2016 David Krause
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#
## This file implements procedures to parse the Nmap address syntax
##
## .. code-block::
##
##  192.168.1,2.10-20,100-200
##
## .. code-block::
##  for ip in ips("192.168.1,2.10-20,100-200"):
##    echo ip
##
## .. code-block::
##  for ip in ips("7d0:db8::594:57ab-57b7,1111"):
##    # warning ipv6 can easily gets huge!
##    echo ip
##
## use iterator `ips` to iterate all ips in the expandet range
##

import net
import strutils
import parseutils
import strutils
import sequtils
#import macros

iterator buildIpAddressV4(se: seq[seq[int]]): IpAddress =
  ## build sequenze of IpAddress out of eg @[@[10], @[1, 2, 3], @[0], @[4, 5, 6]]
  # TODO this is stupid
  # TODO maybe macro can solve this...
  if se.len == 4:
    for one in se[0]:
      for two in se[1]:
        for three in se[2]:
          for four in se[3]:
            yield parseIpAddress("$1.$2.$3.$4" % [
              $one, 
              $two, 
              $three, 
              $four])

iterator buildIpAddressV6(se: seq[seq[int]]): IpAddress =
  ## build sequenze of IpAddress out of 
  ## ## @[@[2000], @[0db8], @[0], @[0], @[0], @[0], @[1428, afe1], @[57ab, 1aed, f1e3]]
  # TODO this is stupid
  if se.len == 8:
    for one in se[0]:
      for two in se[1]:
        for three in se[2]:
          for four in se[3]:
            for five in se[4]:
              for six in se[5]:
                for seven in se[6]:
                  for eight in se[7]:
                    yield parseIpAddress("$1:$2:$3:$4:$5:$6:$7:$8" % [
                      $(toHex one),
                      $(toHex two),
                      $(toHex three),
                      $(toHex four),
                      $(toHex five),
                      $(toHex six),
                      $(toHex seven),
                      $(toHex eight)])


proc expandV4(ips: string): seq[seq[int]] =
  var octets: seq[seq[int]] = @[]
  for octet in ips.split("."):
    if not (',' in octet) and not ('-' in octet):
      octets.add(@[ parseInt octet])
    else:
      var buf: seq[int] = @[]
      for comSep in octet.split(","):
        if "-" in comSep:
          var rangeParts = comSep.split("-")
          for i in (parseInt rangeParts[0])..(parseInt rangeParts[1]):
            buf.add(i)
        else:
          buf.add(parseInt comSep)
      octets.add(buf)
  return octets

proc fillV6(ip: string): string =
  ## fill ip with missing ':' to circumvent
  ## stupid generate function
  let actCount = ip.count(":")
  let haveToCount = 7
  if actCount < haveToCount:
    result = ip.replace("::", ":".repeat(actCount + 1))
  else:
    result = ip

proc expandV6(ips: string): seq[seq[int]] =
  var octets: seq[seq[int]] = @[]
  for octet in ips.fillV6().split(":"):
    if not (',' in octet) and not ('-' in octet):
      octets.add(@[ parseHexInt octet])
    else:
      var buf: seq[int] = @[]
      for comSep in octet.split(","):
        if "-" in comSep:
          var rangeParts = comSep.split("-")
          for i in (parseHexInt rangeParts[0])..(parseHexInt rangeParts[1]):
            buf.add(i)
        else:
          buf.add(parseHexInt comSep)
      octets.add(buf)
  return octets


iterator ips*(ipStr: string): IpAddress =
  ## this parses a string like this 
  ##
  ## .. code-block::
  ##   "192.168.1,2.10-100"
  ##
  ## or
  ##
  ## .. code-block::
  ##   "7d0:db8::594:57ab-57b7,1111"
  ## and yields an IpAddress for every ip in the range.
  var ranges: seq[seq[int]]
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

  assert toSeq(ips("10.0.0.1,2,4-6")) == @[ 
    parseIpAddress "10.0.0.1",
    parseIpAddress "10.0.0.2",
    parseIpAddress "10.0.0.4",
    parseIpAddress "10.0.0.5",  
    parseIpAddress "10.0.0.6"]

  assert toSeq(ips("10.0.0.3-6")) == @[
    parseIpAddress "10.0.0.3",
    parseIpAddress "10.0.0.4",
    parseIpAddress "10.0.0.5",
    parseIpAddress "10.0.0.6"]

  assert toSeq(ips("10.0.1-2.1-3")) == @[
    parseIpAddress "10.0.1.1",
    parseIpAddress "10.0.1.2",
    parseIpAddress "10.0.1.3",
    parseIpAddress "10.0.2.1",
    parseIpAddress "10.0.2.2",
    parseIpAddress "10.0.2.3",]
  
  assert toSeq(ips("7d0:db8::594:57b0,57b2-57b4")) == @[
    parseIpAddress "7d0:db8::594:57b0",
    parseIpAddress "7d0:db8::594:57b2",
    parseIpAddress "7d0:db8::594:57b3",
    parseIpAddress "7d0:db8::594:57b4"]

  # ## Future...
  # assert toSeq(ips("10.0.0.0/24")) == @["10.0.0.1", "10.0.0.2", "10.0.0.4", "10.0.0.5", "10.0.0.6"]
  # assert "10.0.0.1" in ips("10.0.1-2.1,2,3-50") == false
  # assert "10.0.0.1" in ips("10.0.0-2.1,2,3-50") == true


when isMainModule:
  for ip in ips("192.168.1,2.1-10"):
   echo ip
  for ip in ips("7d0:db8::594:57ab-57b7,1111"):
    echo ip