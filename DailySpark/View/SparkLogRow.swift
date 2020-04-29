//
//  SparkLogRow.swift
//  Spark A Day
//
//  Created by Malcom Jones on 4/27/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import SwiftUI

struct SparkLogRow: View {
    
    var spark: [String] = []
    
    var body: some View {
        HStack {
            Text(spark[1])
            Spacer()
            Text(spark[0])
        }
        .padding()
    }
}

struct SparkLogRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SparkLogRow(spark: ["Tool", "Step Into Your Power"])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
