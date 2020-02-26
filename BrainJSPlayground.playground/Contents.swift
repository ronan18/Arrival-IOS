import UIKit
import JavaScriptCore
var jsContext: JSContext!
var str = "Hello, playground"

func initializeJS() {
    jsContext = JSContext()
    let jsSourcePathTwo = Bundle.main.path(forResource: "brain-browser.min", ofType: "js")
    if let jsSourcePath = Bundle.main.path(forResource: "brain-browser.min", ofType: "js") {
           do {
               // Load its contents to a String variable.
               let jsSourceContents = try String(contentsOfFile: jsSourcePath)
            let jsSourceTwoContents = try String(contentsOfFile: jsSourcePathTwo!)
    
               // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
               jsContext.evaluateScript(jsSourceContents)
            let brainFunction = jsContext.objectForKeyedSubscript("brain")
           }
           catch {
               print(error.localizedDescription)
           }
       }
 
}
