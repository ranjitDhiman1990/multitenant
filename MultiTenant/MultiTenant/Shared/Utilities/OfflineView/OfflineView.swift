//
//  OfflineView.swift
//  MultiTenant
//
//  Created by Dhiman Ranjit on 25/09/24.
//

import SwiftUI

struct OfflineView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .padding(.bottom, 20)
            
            Text("Network connection\nseems to be offline.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
            Text("Please check your\nconnectivity.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
    }
}

struct OfflineView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineView()
    }
}

