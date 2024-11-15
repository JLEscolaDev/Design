//
//  SimplifiedTextFieldView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 4/11/24.
//

import SwiftUI

public struct SimplifiedTextFieldView: View {
    @State var vm: SimplifiedTextFieldViewModel

    public var body: some View {
        Group {
            if vm.isSecure {
                SecureField(vm.placeholder, text: $vm.text)
                    .padding(vm.padding)
                    .font(.system(size: vm.fontSize))
                    .background(vm.backgroundColor)
                    .foregroundColor(vm.textColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: vm.borderRadius)
                            .stroke(vm.borderColor, lineWidth: 1)
                    )
                    .cornerRadius(vm.borderRadius)
                    .shadow(color: vm.shadowColor.opacity(vm.shadowOpacity), radius: vm.shadowRadius, x: 0, y: 5)
            } else {
                TextField(vm.placeholder, text: $vm.text)
                    .padding(vm.padding)
                    .font(.system(size: vm.fontSize))
                    .background(vm.backgroundColor)
                    .foregroundColor(vm.textColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: vm.borderRadius)
                            .stroke(vm.borderColor, lineWidth: 1)
                    )
                    .cornerRadius(vm.borderRadius)
                    .shadow(color: vm.shadowColor.opacity(vm.shadowOpacity), radius: vm.shadowRadius, x: 0, y: 5)
            }
        }
    }
}

// MARK: - Preview
extension SimplifiedTextFieldView {
    public static var preview: some View {
        SimplifiedTextFieldPreview()
    }
}

private struct SimplifiedTextFieldPreview: View {
    @State private var nameFieldModel = SimplifiedTextFieldViewModel(placeholder: "Nombre Completo")
    @State private var passwordFieldModel = SimplifiedTextFieldViewModel(placeholder: "Contraseña", isSecure: true)

    var body: some View {
        VStack(spacing: 20) {
            SimplifiedTextFieldView(vm: nameFieldModel)
            SimplifiedTextFieldView(vm: passwordFieldModel)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

#Preview {
    SimplifiedTextFieldView.preview
}
