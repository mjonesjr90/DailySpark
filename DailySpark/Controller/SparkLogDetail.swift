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
                    .lineLimit(10)
                    .minimumScaleFactor(0.2)
                    .padding(.bottom)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color(.sRGB, red: 180/255, green: 180/255, blue: 180/255, opacity: 1), radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(UIColor.systemBackground), lineWidth: 1)
//                    .stroke(Color(.sRGB, red: 255/255, green: 255/255, blue: 255/255, opacity: 1), lineWidth: 1)
            )
                .padding([.top, .horizontal])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct SparkLogDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        SparkLogDetail(sparkHeader: "Step Into Your Power", sparkCategory: "Tools", sparkBody: "Answer this prompt in 5 different ways:  \"If I step into my power, ____________\"", show: .constant(true))
    }
}
