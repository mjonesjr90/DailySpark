//
//  SparkView.swift
//  Spark A Day
//
//  Created by Malcom Jones on 4/27/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import SwiftUI

struct SparkLogDetail: View {
    
    var sparkHeader: String
    var sparkCategory: String
    var sparkBody: String
    
    @Binding var show : Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(sparkHeader)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.2)
                    .padding(.top)
                Text(sparkCategory)
                    .font(.headline)
                    .fontWeight(.light)
                    .padding([.top, .bottom])

                Text(sparkBody)
                    .font(.body)
                    .padding(.bottom)
            }
            .padding()
            .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 245/255, opacity: 1))
            .cornerRadius(5)
            .shadow(color: Color(.sRGB, red: 120/255, green: 120/255, blue: 120/255, opacity: 1), radius: 2, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.sRGB, red: 245/255, green: 245/255, blue: 245/255, opacity: 1), lineWidth: 1)
            )
                .padding([.horizontal])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SparkLogDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        SparkLogDetail(sparkHeader: "Step Into Your Power", sparkCategory: "Tools", sparkBody: "Answer this prompt in 5 different ways:  \"If I step into my power, ____________\"", show: .constant(true))
    }
}
