import Cocoa
import Darwin

struct User{
    //academicsafe@gmail.com
    var firstName: String
    var lastName: String
    var emailAddress: String
    var emailForChild: String {
        var newEmail = emailAddress
            newEmail = newEmail.replacingOccurrences(of: ".", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "@", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "$", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "%", with: "_")
            return newEmail
    }
   
}

let user = User(firstName: "Jerry", lastName: "Zweli", emailAddress: "Oc%hwe98@gmail.com")
print(user.emailForChild)
print(user.emailAddress)
