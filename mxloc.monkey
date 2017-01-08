Strict
Import brl.process
Import brl.filesystem
Import os

Function Main:Int()
    Local path:String = ProjectPathFromArg()
    If Not path
        Print "Specify the project folder as argument."
        Print "Exiting ..."
        Return 1
    End

    Local files:= AllFilesOf(path)
    Local lineCount:Int
    Local emptyLines:Int
    Local comments:Int
    For Local i:Int = 0 Until files.Length
        Local code:String = os.LoadString(path + "/" + files[i])
        If code
            lineCount += CountLines(code)
            emptyLines += CountLinesEmpty(code)
            comments += CountCommentLines(code)
        End
    Next
    Print "mxloc version 0.1"
    Print "*****************"
    Print "files:" + files.Length
    Print "lines:" + lineCount
    Print "empty:" + emptyLines
    Print "comments: " + comments
    Return 0
End

Function ProjectPathFromArg:String()
    Local args:= os.AppArgs()
    If args.Length <> 2
        Return ""
    End
    Return args[1]
End

Function AllFilesOf:String[](path:String)
    Local files:= filesystem.LoadDir(path, True)
    Local curated:= New StringStack
    For Local i:Int = 0 Until files.Length
        If files[i].EndsWith(".monkey")
            curated.Push(files[i])
        End
    Next
    Return curated.ToArray()
End

Function CountLines:Int(code:String)
    Local lines:String[] = code.Split("~n")
    Return lines.Length
End

Function CountLinesEmpty:Int(code:String)
    Local lines:String[] = code.Split("~n")
    Local emptyLines:Int
    For Local i:Int = 0 Until lines.Length
        If lines[i].Trim() = ""
            emptyLines += 1
        End
    Next
    Return emptyLines
End

Function CountCommentLines:Int(code:String)
    Local lines:String[] = code.Split("~n")
    Local comments:Int
    Local rem:Bool
    For Local i:Int = 0 Until lines.Length
        Local line:String = lines[i].Trim().ToLower()
        If rem
            comments += 1
            If line.StartsWith("#end")
                rem = False
            End
        ElseIf line.StartsWith("'")
            comments += 1
        ElseIf line.StartsWith("#rem")
            rem = True
            comments += 1
        End
    Next
    Return comments
End
