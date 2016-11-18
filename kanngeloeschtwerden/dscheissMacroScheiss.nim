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




static:
  # var root = newStmtList( 
  #   newNimNode(nnkForStmt)
  #   # infix( 
  #   #   newIntLitNode(5), 
  #   #   "*", 
  #   #   newPar( 
  #   #     infix( 
  #   #       newIntLitNode(5), 
  #   #       "+", 
  #   #       newIntLitNode(10) 
  #   #     ) 
  #   #   ) 
  #   # ) 
  # ) 
  # var root = parseStmt(
#     """    
# ForStmt
#   Ident !"two"
#   BracketExpr
#     Ident !"se"
#     IntLit 1    
#     """)
  # echo(root.repr)






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
