//
//  ViewControllerWrapper.swift
//  Spark A Day
//
//  Created by Malcom Jones on 4/28/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import SwiftUI

struct ViewControllerWrapper: UIViewControllerRepresentable {
    func updateUIViewController(_ viewContoller: UIViewController, context: Context) {
        //
    }
    

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "ViewController")
        return viewController
    }


}
