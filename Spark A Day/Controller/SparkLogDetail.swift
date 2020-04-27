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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(sparkHeader)
                .font(.title)
                .fontWeight(.bold)
            Text(sparkCategory)
                .font(.headline)
                .fontWeight(.light)
                .padding(.bottom)
            Text(sparkBody)
                .font(.body)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

struct SparkLogDetail_Previews: PreviewProvider {
    static var previews: some View {
        SparkLogDetail(sparkHeader: "Step Into Your Power", sparkCategory: "Tools", sparkBody: "Answer this prompt in 5 different ways:  \"If I step into my power, ____________\"")
    }
}
