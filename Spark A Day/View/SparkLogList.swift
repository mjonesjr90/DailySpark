//
//  SparkLogView.swift
//  Spark A Day
//
//  Created by Malcom Jones on 3/1/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import SwiftUI
import os.log

struct SparkLogList: View {
    
    var sparkArray: [[String]]
    
    var body: some View {
        NavigationView {
            List (sparkArray, id: \.self) { spark in
                NavigationLink(destination: SparkLogDetail(sparkHeader: spark[1], sparkCategory: spark[0], sparkBody: spark[3])) {
                    SparkLogRow(spark: spark)
                }
            }
            .navigationBarTitle(Text("Spark Log"))
        }
    }
}

struct SparkLogList_Previews: PreviewProvider {
    static var previews: some View {
        SparkLogList(sparkArray: [
            ["Tools", "Step Into Your Power", "", "Answer this prompt in 5 different ways:  \"If I step into my power, ____________\""],
            ["Practices", "Before you act!", "", "Shoulders down. Practice breathing for your somatic reminder to cultivate a pause and remain in choice."]])
    }
}
