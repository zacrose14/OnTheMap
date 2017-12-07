//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Zachary Rose on 12/7/17.
//  Copyright © 2017 Zachary Rose. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
