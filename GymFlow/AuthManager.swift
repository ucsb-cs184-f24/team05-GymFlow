import FirebaseAuth
import UIKit

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class AuthManager {
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    private var verificationId: String?

    public func startAuth(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
        UIApplication.shared.closeKeyboard()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error during phone authentication: \(error.localizedDescription)")
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .invalidPhoneNumber:
                        completion(false, NSError(domain: "AuthManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid phone number format"]))
                    case .quotaExceeded:
                        completion(false, NSError(domain: "AuthManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "SMS quota exceeded. Please try again later."]))
                    default:
                        completion(false, error)
                    }
                } else {
                    completion(false, error)
                }
                return
            }
            
            guard let verificationId = verificationId else {
                print("Error: Verification ID is nil.")
                completion(false, NSError(domain: "AuthManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Verification ID is nil"]))
                return
            }
            
            self.verificationId = verificationId
            completion(true, nil)
        }
    }

    public func verifyCode(smsCode: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let verificationId = verificationId else {
            print("Error: No verification ID stored.")
            completion(false, NSError(domain: "AuthManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "No verification ID stored"]))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        auth.signIn(with: credential) { authResult, error in
            if let error = error {
                print("Error during sign-in with verification code: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            print("Sign-in successful, user: \(authResult?.user.uid ?? "Unknown User")")
            completion(true, nil)
        }
    }
}
