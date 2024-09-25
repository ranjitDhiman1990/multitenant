//
//  MTTextField.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct MTTextField: View {
    let placeholderText: String
    var backgroundColor: Color?
    var cornerRadius: Double?
    var textCase: Text.Case?
    var keyboardType: UIKeyboardType?
    var textContentType: UITextContentType?
    var textInputAutoCapital: TextInputAutocapitalization?
    var isSecureField: Bool? = false
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack {
                if isSecureField ?? false {
                    SecureField(placeholderText, text: $text)
                        .padding()
                        .background(backgroundColor ?? Color.gray.opacity(0.2))
                        .cornerRadius(cornerRadius ?? 10)
                        .keyboardType(keyboardType != nil ? keyboardType! : .default)
                        .textContentType(textContentType != nil ? textContentType : .none)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(textInputAutoCapital != nil ? textInputAutoCapital : .never)
                        .autocorrectionDisabled()
                } else {
                    TextField(placeholderText, text: $text)
                        .padding()
                        .background(backgroundColor ?? Color.gray.opacity(0.2))
                        .cornerRadius(cornerRadius ?? 10)
                        .keyboardType(keyboardType != nil ? keyboardType! : .default)
                        .textContentType(textContentType != nil ? textContentType : .none)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(textInputAutoCapital != nil ? textInputAutoCapital : .never)
                        .autocorrectionDisabled()
                        .onChange(of: text) { newValue in
                            text = setTextCase(text: text)
                        }
                }
            }
        }
    }
}

struct MTTextField_Previews: PreviewProvider {
    static var previews: some View {
        MTTextField(placeholderText: "Email", isSecureField: false, text: .constant(""))
    }
}

extension MTTextField {
    
    func setTextCase(text: String) -> String {
        if let textCase = textCase {
            if textCase == .uppercase {
                return text.uppercased()
            } else if textCase == .lowercase {
                return text.lowercased()
            }
        }
        return text
    }
}

