import net
import strutils
import parseutils
import sequtils
# import macros



iterator buildIpAddressV4(se: seq[seq[string]]): IpAddress =
  ## build sequenze of IpAddress out of eg @[@[10], @[1, 2, 3], @[0], @[4, 5, 6]]
  # TODO this is stupid
  var buf: string = ""
  if se.len == 4:
    for one in se[0]:
      for two in se[1]:
        for three in se[2]:
          for four in se[3]:
            yield parseIpAddress("$1.$2.$3.$4" % [one,two,three,four] )

  # template ac(actual: seq[string], se:seq[seq[string]]) =
  #   if actual.len < 4:
  #     actual.add()
  #   if actual.len == 4:
  #     yield parseIpAddress("$1.$2.$3.$4" % actual )

  # var buf: string = ""
  # if se.len == 4:  

iterator buildIpAddressV6(se: seq[seq[string]]): IpAddress =
  ## build sequenze of IpAddress out of @[@[10], @[1, 2, 3], @[0], @[4, 5, 6]]
  # result = @[]
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

# dumpTree:
#   for one in se[0]:
#     for two in se[1]:
#       for three in se[2]:
#         for four in se[3]:
#           # discard
#           yield parseIpAddress("$1.$2.$3.$4" % [one,two,three,four] )

# proc parseEnum*[T: enum](s: string): T =
#   macro m: stmt =
#     result = newStmtList()
#     for e in T: result.add parseStmt(
#       "uggu cmpIgnoreStyle(s, \"$1\") == 0: return $1".format(e))

#     result.add parseStmt(
#       "raise newException(ValueError, \"invalid enum value: \"&s)")

#     #echo result.repr # To make sure we get what we want

#   m() # Actually invoke the macro to insert the statements here    


# macro debug(n: int): stmt =
#   result = newStmtList()
#   var s= ""
#   for each in 0..intVal(n).int:
#     s=s & "for each$1 in se[$1]:\n  " % @[$each] 
#   s=s & "  echo 1"
#   result.add parseStmt( s)
# var se = @["asd","asdd"]
# # for each in se[1]:
# #   echo 1
# debug(1)

#   var foo = ""
  # for each in 1..2:
    # var list = newStmtList()  
    # result = newStmtList()  
    # result.add parseStmt("for each in se[$1]: return true".format(each))


    # nnkForStmt($each,"","","")
    # foo = 
    #   """
    #   StmtList
    #     ForStmt
    #       Ident !"$1"
    #       BracketExpr
    #         Ident !"se"
    #         IntLit $1""" % [$each]
    # result.add(parseStmt foo)

  # return 

# debug(1)

# echo treeRepr newNnk """StmtList
  # ForStmt
  #   Ident !"one"
  #   BracketExpr
  #     Ident !"se"
  #     IntLit 0
  #   StmtList
  #     ForStmt
  #       Ident !"two"
  #       BracketExpr
  #         Ident !"se"
  #         IntLit 1
  #       StmtList
  #         ForStmt
  #           Ident !"three"
  #           BracketExpr
  #             Ident !"se"
  #             IntLit 2
  #           StmtList
  #             ForStmt
  #               Ident !"four"
  #               BracketExpr
  #                 Ident !"se"
  #                 IntLit 3
  #               StmtList
  #                 YieldStmt
  #                   Call
  #                     Ident !"parseIpAddress"
  #                     Infix
  #                       Ident !"%"
  #                       StrLit $1.$2.$3.$4
  #                       Bracket
  #                         Ident !"one"
  #                         Ident !"two"
  #                         Ident !"three"
  #                         Ident !"four""""









# repr:
#   for one in se[0]:
#     for two in se[1]:
#       for three in se[2]:
#         for four in se[3]:
#           discard

# treeRepr:
  # newStmtList
#     newForStmt:
#       newIdent !"one"
#       newBracketExpr
#         newIdent !"se"
#         newIntLit 0

# when isMainModule:
  # assert buildIpAddresses(nmapIp("10.0.0.1,2,3")) == @[parseIpAddress "10.0.0.1", parseIpAddress "10.0.0.2", parseIpAddress "10.0.0.3"]
  # assert ip("10.0.0.1,2,4-6") == @[ parseIpAddress "10.0.0.1",  parseIpAddress "10.0.0.2",  parseIpAddress "10.0.0.4",  parseIpAddress "10.0.0.5",  parseIpAddress "10.0.0.6"]
  # assert ip("10.0.0.3-6") == @["10.0.0.3", "10.0.0.4", "10.0.0.5", "10.0.0.6"]
  # assert ip("10.0.1-2.1-3") == @["10.0.1.1", "10.0.1.2", "10.0.1.3", "10.0.2.1", "10.0.2.2", "10.0.2.3",]
  #assert ip("10.0.0.0/24") == @["10.0.0.1", "10.0.0.2", "10.0.0.4", "10.0.0.5", "10.0.0.6"]
