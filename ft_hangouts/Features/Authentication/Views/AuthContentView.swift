//
//  AuthContentView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 22/10/2025.
//

import SwiftUI

struct AuthContentView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            PhoneNumberLoginView(viewModel: viewModel)
            
            if viewModel.verificationID != nil {
                VerificationCodeView(viewModel: viewModel)
            }
            
            Spacer()
        }
    }
}

private struct PhoneNumberLoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        Image(systemName: "phone.fill")
            .font(.system(size: 80))
            .foregroundColor(.blue)
        
        Text("SIGN_IN".localized(using: viewModel.localizationManager))
            .font(.title)
            .bold()
            .padding(.top)
        
        TextField("PHONE_NUMBER".localized(using: viewModel.localizationManager, arguments: ""), text: $viewModel.phoneNumber)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.phonePad)
            .padding(.horizontal)
            .onChange(of: viewModel.phoneNumber) {
                viewModel.formatPhoneNumber()
            }
        
        Button("SEND_CODE".localized(using: viewModel.localizationManager)) {
            viewModel.verifyPhoneNumber()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

private struct VerificationCodeView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        TextField("VERIFICATION_CODE".localized(using: viewModel.localizationManager), text: $viewModel.verificationCode)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
            .padding(.horizontal)
        
        Button("VERIFY_SIGNIN".localized(using: viewModel.localizationManager)) {
            viewModel.signIn()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
