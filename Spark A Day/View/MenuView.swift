//
//  MenuView.swift
//  Spark A Day
//
//  Created by Malcom Jones on 4/28/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import SwiftUI
import os

struct MenuView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
//        NavigationView {
            VStack(alignment: .leading) {
                MenuWrapper()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
//            .navigationBarTitle(Text("Menu"))
//        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
//        MenuView(dismissAction: {
//            (() -> Void).self
//        })
        MenuView()
    }
}
