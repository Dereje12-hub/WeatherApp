import UIKit

var greeting = "Hello, playground"
var string = "[[{[]}]]" //"[[[]{]}]"



func checkBalance( _ str: String) ->  Bool {
    guard ((str.count % 2) == 0) else { return false }
    
    var stack: [Character] = []
    
    for i in str {
        switch i {
        case "(":
            stack.append(")")
            print(stack)
        case "{":
            stack.append("}")
            print("{ = "+stack)
        case "[":
            stack.append("]")
            print("[ = "+stack)
        default:
            if stack.isEmpty || stack.removeLast() != i {
                print(stack)
                return false
            }
        }
    }
    print(stack)
    return stack.isEmpty
}

print(checkBalance(string))


