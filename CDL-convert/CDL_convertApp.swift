//
//  CDL_convertApp.swift
//  CDL-convert
//
//  Created by Preston Mohr on 1/27/23.
//

import SwiftUI

@main
struct CDL_convertApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            SidebarView()
                .frame(minWidth:600)
            #else
            ContentViewGenerateCDL()
            #endif
        }
    }
}

struct settingVariables {
    static var decimalPlaces: Int = 4
    
    //number formatter for slope values : 0 <= slope < 4
    static var numberFormatterSlope = NumberFormatter()
    //number formatter for offset values : -1 < offset < 1
    static var numberFormatterOffset = NumberFormatter()
    //number formatter for power values : 0.5 <= power <= 2
    static var numberFormatterPower = NumberFormatter()
    //number formatter for saturation value : 0 <= saturation < 2
    static var numberFormatterSaturation = NumberFormatter()
}
