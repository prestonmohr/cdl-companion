//
//  ContentViewColorScience.swift
//  CDL Companion
//
//  Created by Preston Mohr on 1/29/23.
//

import SwiftUI

struct ContentViewColorScience: View {
    
    var body: some View {
        ScrollView {
            Section {
                Text("ASC CDL Science")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .bold()
                Section {
                    VStack{
                        Text("Combined Function\n")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                        Section {
                            Text("The formula for ASC CDL color correction is:\n")
                            Text("\tout = (i × s + o) ")
                                .font(.system(.title3, design: .serif))
                                .italic()+Text("p").font(.system(.footnote, design: .serif))
                                .baselineOffset(5).italic()+Text("\n")
                            Text("where\n")
                            Text("\tout")
                                .font(.system(.title3, design: .serif))
                                .italic()+Text("  is the color graded pixel code value\n")
                            Text("\ti")
                                .font(.system(.title3, design: .serif))
                                .italic()+Text("  is the input pixel code value (0=black, 1=white)\n")
                            Text("\ts")
                                .font(.system(.title3, design: .serif))
                                .italic()+Text("  is slope (any number 0 or greater, nominal value is 1.0)\n")
                            Text("\to")
                                .font(.system(.title3, design: .serif))
                                .italic()+Text("  is offset (any number, nominal value is 0)\n")
                            Text("\tp")
                                .font(.system(.title3, design: .serif))
                                .italic()+Text("  is power (any number greater than 0, nominal value is 1.0)\n")
                            Text("The formula is applied to the three color values for each pixel using the corresponding slope, offset, and power numbers for each color channel.")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                    VStack {
                        Text("The ASC CDL Format\n")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                        Text("The ASC CDL (American Society of Cinematographers Color Decision List) is a widely recognized and widely used color grading format. Despite its popularity, many individuals are unaware of its origins and significance in the production and post-production pipeline.\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("For many years, the industry has relied on a standard set of controls for color grading, including lift, gamma, and gain. However, these generalized descriptions have caused many interpretive issues. Each manufacturer has their own unique interpretation of these controls, leading to variations in results across different software systems. This lack of standardization prompted the American Society of Cinematographers to create a new set of mathematical transforms that would manipulate images in a predictable manner and allow for an independent, unambiguous way of describing color manipulations.\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("The ASC CDL system replaces the lift, gamma, and gain controls with three new transforms: offset, power, and slope. The offset control, which does not have a pivot, acts like an 'exposure' control and adds or subtracts the same value to or from each original value, as opposed to a range-limited control like a lift control. This makes signal manipulation by the ASC CDL more analogous to a 'contrast and exposure' control system.\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom)
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.top)
            .padding(.bottom)
                        
        }
        .padding(.bottom)
    }
}


/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentViewColorScience()
 }
 }
 */

