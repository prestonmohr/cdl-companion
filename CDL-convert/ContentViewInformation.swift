//
//  ContentView.swift
//  CDL-convert
//
//  Created by Preston Mohr on 1/27/23.
//

import SwiftUI

struct ContentViewInformation: View {
    
    var body: some View {
        ScrollView {
            Section {
                Text("ASC CDL Background")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .bold()
                Section {
                    VStack{
                        Text("Background\n")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                        Section {
                            Text("The ASC CDL (American Society of Cinematographers Color Decision List) is a set of guidelines and specifications for color correction and color grading in the film and television industry. It was developed by the American Society of Cinematographers (ASC) in order to standardize the process of color correction across different productions and post-production facilities.\n")
                            Text("The ASC CDL was created in response to the growing need for a consistent and reliable way to manage color information during the post-production process. With the advent of digital filmmaking and the increasing use of computer-based color correction tools, it became clear that a more standardized approach was needed in order to ensure that colors would look consistent across different productions and different viewing environments.\n")
                            Text("The ASC CDL consists of a set of 10 parameters, known as the 'CDL coefficients,' that can be used to adjust the color, contrast, and saturation of a shot. These parameters include the slope, offset, and power of the red, green, and blue channels, as well as the saturation of the image. By using the CDL coefficients, colorists and other post-production professionals can make precise and consistent adjustments to the color of a shot, regardless of the particular hardware or software being used.\n")
                            Text("The ASC CDL is widely used in the film and television industry, and is supported by a wide range of color correction and grading software, as well as by many cameras and other imaging equipment. It has become an industry standard for color correction and is used by major Hollywood studios, independent filmmakers, and television networks around the world.\n")
                            Text("The ASC CDL not only helps ensure consistency in color across different productions, but also helps streamline the post-production process. With a standardized approach to color correction, it is easier for colorists and other post-production professionals to collaborate and share information, which can save time and money on productions. Additionally, by using the ASC CDL, it is possible to ensure that the final product will look good regardless of the viewing environment, whether it is on a movie theater, television, or computer screen.\n")
                            Text("For more information, please visit [The American Society of Cinematographers website](https://theasc.com/)")
                        }
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
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
 ContentViewGenerateCDL()
 }
 }
 */

