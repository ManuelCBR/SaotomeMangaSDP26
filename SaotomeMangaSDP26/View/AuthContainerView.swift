//
//  AuthContainerView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 22/2/26.
//

import SwiftUI

/// Vista contenedora que decide si mostrar LoginView o ContentView
/// según el estado de autenticación
struct AuthContainerView: View {
    @Environment(AuthViewModel.self) private var authVM
    
    var body: some View {
        Group {
            if authVM.isAuthenticated {
                ContentView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authVM.isAuthenticated)
    }
}

#Preview {
    AuthContainerView()
        .environment(AuthViewModel())
}
