//
//  SplashView.swift
//  POC
//
//  Created by chandra sekhar p on 05/08/24.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject var viewModel: SplashViewModel = SplashViewModel()
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOpacity: Double = 1.0
    @State private var textScale: CGFloat = 1.0
    @State private var textOpacity: Double = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            Image("login")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        self.logoScale = 0.8
                        self.logoOpacity = 0.7
                    }
                }
            
            Text("Welcome to Foodie")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
                .scaleEffect(textScale)
                .opacity(textOpacity)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        self.textScale = 1
                        self.textOpacity = 0.5
                    }
                }
            Spacer()
            Spacer()
        }
        .onAppear {
            viewModel.validateUser()
        }
    }
}
     
#Preview {
    SplashView()
}


