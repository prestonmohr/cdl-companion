//
//  ContentView.swift
//  CDL-convert
//
//  Created by Preston Mohr on 1/27/23.
//

import SwiftUI

struct ContentViewGenerateCDL: View {
    
    @State private var slopeR: Double = 1.0000
    @State private var slopeG: Double = 1.0000
    @State private var slopeB: Double = 1.0000
    @State private var offsetR: Double = 0.0000
    @State private var offsetG: Double = 0.0000
    @State private var offsetB: Double = 0.0000
    @State private var powerR: Double = 1.0000
    @State private var powerG: Double = 1.0000
    @State private var powerB: Double = 1.0000
    @State private var saturation: Double = 1.0000
    @State private var selectedFileType = 0
    @State private var fileType = ["cc", "ccc", "cdl", "rcdl"]
    @State private var fileName: String = ""
    @State private var showSavePanel = false
    @State private var selectedURL: URL? = nil
    @State var decimalPlaces: Int = settingVariables.decimalPlaces
    
    //number formatter for slope values : 0 <= slope < 4
    @State private var numberFormatterSlope = settingVariables.numberFormatterSlope
    //number formatter for offset values : -1 < offset < 1
    @State private var numberFormatterOffset = settingVariables.numberFormatterOffset
    //number formatter for power values : 0.5 <= power <= 2
    @State private var numberFormatterPower = settingVariables.numberFormatterPower
    //number formatter for saturation value : 0 <= saturation < 2
    @State private var numberFormatterSaturation = settingVariables.numberFormatterSaturation
    
    @State private var presentPopupSlope: Bool = false
    @State private var presentPopupOffset: Bool = false
    @State private var presentPopupPower: Bool = false
    @State private var presentPopupSaturation: Bool = false
    @State private var presentPopupFiletype: Bool = false
    
    init(){
        setupDecimals()
    }
        
    var body: some View {
        ScrollView {
            Section {
                Text("Generate ASC CDL")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .bold()
                Section {
                    VStack{
                        Text("CDL Name")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                        Text("provide a name for your CDL file")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                        TextField("Enter file name", text: $fileName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minWidth: 300)
                    }
                }
                Section{
                    VStack{
                        HStack {
                            Text("Slope Values")
                                .font(.title2)
                                .bold()
                            Button(action: {
                                presentPopupSlope = true
                            }){
                                Image(systemName: "info.circle")
                            }
                            .foregroundColor(.blue)
                            .popover(isPresented: $presentPopupSlope, arrowEdge: .trailing) {
                              Text("0 ≤ **s** < 4")
                                //.frame(width: 100, height: 100)
                                    .italic()
                                    .font(.body)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("multiplies the incoming data by a factor")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                        HStack {
                            Image(systemName: "r.circle.fill")
                            TextField("Enter slope value for red channel", value: $slopeR, formatter: numberFormatterSlope)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Image(systemName: "g.circle.fill")
                            TextField("Enter slope value for green channel", value: $slopeG, formatter: numberFormatterSlope)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Image(systemName: "b.circle.fill")
                            TextField("Enter slope value for blue channel", value: $slopeB, formatter: numberFormatterSlope)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                Section{
                    VStack{
                        HStack {
                            Text("Offset Values")
                                .font(.title2)
                                .bold()
                            Button(action: {
                                presentPopupOffset = true
                            }){
                                Image(systemName: "info.circle")
                            }
                            .foregroundColor(.blue)
                            .popover(isPresented: $presentPopupOffset, arrowEdge: .trailing) {
                              Text("-1 < **o** < 1")
                                    .italic()
                                    .font(.body)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("applies an offset (adds or subtracts) to the incoming data")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                        HStack {
                            Image(systemName: "r.circle.fill")
                            TextField("Enter offset value for red channel", value: $offsetR, formatter: numberFormatterOffset)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Image(systemName: "g.circle.fill")
                            TextField("Enter offset value for green channel", value: $offsetG, formatter: numberFormatterOffset)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Image(systemName: "b.circle.fill")
                            TextField("Enter offset value for blue channel", value: $offsetB, formatter: numberFormatterOffset)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                Section {
                    VStack {
                        HStack {
                            Text("Power Values")
                                .font(.title2)
                                .bold()
                            Button(action: {
                                presentPopupPower = true
                            }){
                                Image(systemName: "info.circle")
                            }
                            .foregroundColor(.blue)
                            .popover(isPresented: $presentPopupPower, arrowEdge: .trailing) {
                              Text("0.5 ≤ **p** ≤ 2")
                                    .italic()
                                    .font(.body)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("the power function of the results of the incoming data")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                        HStack {
                            Image(systemName: "r.circle.fill")
                            TextField("Enter power value for red channel", value: $powerR, formatter: numberFormatterPower)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Image(systemName: "g.circle.fill")
                            TextField("Enter power value for green channel", value: $powerG, formatter: numberFormatterPower)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Image(systemName: "b.circle.fill")
                            TextField("Enter power value for blue channel", value: $powerB, formatter: numberFormatterPower)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                Section {
                    VStack {
                        HStack {
                            Text("Saturation Value")
                                .font(.title2)
                                .bold()
                            Button(action: {
                                presentPopupSaturation = true
                            }){
                                Image(systemName: "info.circle")
                            }
                            .foregroundColor(.blue)
                            .popover(isPresented: $presentPopupSaturation, arrowEdge: .trailing) {
                              Text("0 ≤ **sat** < 2")
                                    .italic()
                                    .font(.body)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("saturates / desaturates the colors (with color components weighted with values from the Rec.709 matrix)")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                        HStack {
                            Image(systemName: "s.circle.fill")
                            TextField("Enter saturation value", value: $saturation, formatter: numberFormatterSaturation)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                
                Section {
                    VStack {
                        HStack {
                            Text("Filetype")
                                .font(.title2)
                                .bold()
                            Button(action: {
                                presentPopupFiletype = true
                            }){
                                Image(systemName: "info.circle")
                            }
                            .foregroundColor(.blue)
                            .popover(isPresented: $presentPopupFiletype, arrowEdge: .trailing) {
                              Text("choose between **ColorCorrection**, **ColorCorrectionCollection**, and **ColorDecisionList**")
                                    .italic()
                                    .font(.body)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("choose from .cc, .ccc, .cdl, .rcdl")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                    }
                    HStack {
                        Picker(selection: $selectedFileType, label: Text("Filetype")) {
                            ForEach(0..<fileType.count) {
                                Text(self.fileType[$0])
                            }
                        }
                        Button(action: {
                            //self.showSavePanel = true
                            // create the file content
                            let fileType = self.fileType[selectedFileType]
                            let fileContent = generateFileContent(fileName: fileName, slope: [slopeR, slopeG, slopeB], offset: [offsetR, offsetG, offsetB], power: [powerR, powerG, powerB], saturation: saturation, fileType: fileType)
                            
                            // Open the system save window with the fileURL and defaultFileName as the suggested name
                            let savePanel = NSSavePanel()
                            if (fileName == "") {
                                savePanel.nameFieldStringValue = "Untitled" + "." + fileType
                            }
                            else {
                                savePanel.nameFieldStringValue = fileName + "." + fileType
                            }
                            savePanel.begin { (result) in
                                if result == .OK {
                                    if let url = savePanel.url {
                                        do {
                                            try fileContent.write(to: url, atomically: true, encoding: .utf8)
                                        } catch {
                                            print("Failed to save file: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                        }){
                            Text("Save File")
                        }
                    }
                }
                Section {
                    Divider()
                        .padding(.top)
                        .padding(.bottom)
                    VStack {
                        Text("Options")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            //.bold()
                        Text("configure CDL options")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                        HStack {
                            Text("Decimal Precision")
                            Button(action: {
                                if (settingVariables.decimalPlaces >= 3) {
                                    settingVariables.decimalPlaces = settingVariables.decimalPlaces - 1
                                    setupDecimals()
                                    decimalPlaces = settingVariables.decimalPlaces
                                }
                            }){
                                Image(systemName: "minus.circle")
                            }
                            .padding(.leading)
                            
                            
                            Button(action: {
                                if (settingVariables.decimalPlaces < 10) {
                                    settingVariables.decimalPlaces = settingVariables.decimalPlaces + 1
                                    setupDecimals()
                                    decimalPlaces = settingVariables.decimalPlaces
                                }
                            }){
                                Image(systemName: "plus.circle")
                            }
                            
                            Text(String(self.decimalPlaces))
                            .frame(minWidth: 10)
                            .hidden()
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.top)
            .padding(.bottom)
        }
        .padding(.bottom)
    }
    
    func setupDecimals() {
        settingVariables.numberFormatterSlope.minimumFractionDigits = settingVariables.decimalPlaces
        settingVariables.numberFormatterSlope.maximumFractionDigits = settingVariables.decimalPlaces
        settingVariables.numberFormatterSlope.minimum = 0.0000
        settingVariables.numberFormatterSlope.maximum = (4.0000 - (1/(pow(10,Double(settingVariables.decimalPlaces))))) as NSNumber
        
        settingVariables.numberFormatterOffset.minimumFractionDigits = settingVariables.decimalPlaces
        settingVariables.numberFormatterOffset.maximumFractionDigits = settingVariables.decimalPlaces
        settingVariables.numberFormatterOffset.minimum = (-1.0000 + (1/(pow(10,Double(settingVariables.decimalPlaces))))) as NSNumber
        settingVariables.numberFormatterOffset.maximum = (1.0000 - (1/(pow(10,Double(settingVariables.decimalPlaces))))) as NSNumber
        
        settingVariables.numberFormatterPower.minimumFractionDigits = settingVariables.decimalPlaces
        settingVariables.numberFormatterPower.maximumFractionDigits = settingVariables.decimalPlaces
        settingVariables.numberFormatterPower.minimum = 0.5000
        settingVariables.numberFormatterPower.maximum = 2.0000
        
        settingVariables.numberFormatterSaturation.minimumFractionDigits = settingVariables.decimalPlaces
        settingVariables.numberFormatterSaturation.maximumFractionDigits = settingVariables.decimalPlaces
        settingVariables.numberFormatterSaturation.minimum = 0.0000
        settingVariables.numberFormatterSaturation.maximum = (2.0000 - (1/(pow(10,Double(settingVariables.decimalPlaces))))) as NSNumber
    }
    
    func generateFile(url: URL) {
        selectedURL = url
        let fileType = self.fileType[selectedFileType]
        let fileContent = generateFileContent(fileName: fileName, slope: [slopeR, slopeG, slopeB], offset: [offsetR, offsetG, offsetB], power: [powerR, powerG, powerB], saturation: saturation, fileType: fileType)
        print("Outputted to file:" + fileContent)
        do {
            try fileContent.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write file")
        }
    }
    
    func generateFileContent(fileName: String, slope: [Double], offset: [Double], power: [Double], saturation: Double, fileType: String) -> String {
        var fileContent = ""
        switch fileType {
        case "cc":
            fileContent = """
                <?xml version="1.0" encoding="UTF-8"?>
                <ColorCorrection id="\(fileName)">
                    <SOPNode>
                        <Slope>\(String(format: "%.\(settingVariables.decimalPlaces)f", slope[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", slope[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", slope[2]))</Slope>
                        <Offset>\(String(format: "%.\(settingVariables.decimalPlaces)f", offset[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[2]))</Offset>
                        <Power>\(String(format: "%.\(settingVariables.decimalPlaces)f", power[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[2]))</Power>
                    </SOPNode>
                    <SatNode>
                        <Saturation>\(String(format: "%.\(settingVariables.decimalPlaces)f", saturation))</Saturation>
                    </SatNode>
                </ColorCorrection>
                """
        case "ccc":
            fileContent = """
                <?xml version="1.0" encoding="UTF-8"?>
                <ColorCorrectionCollection xmlns="urn:ASC:CDL:v1.2">
                <ColorCorrection id="\(fileName)">
                    <SOPNode>
                        <Slope>\(String(format: "%.\(settingVariables.decimalPlaces)f", slope[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", slope[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", slope[2]))</Slope>
                        <Offset>\(String(format: "%.\(settingVariables.decimalPlaces)f", offset[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[2]))</Offset>
                        <Power>\(String(format: "%.\(settingVariables.decimalPlaces)f", power[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[2]))</Power>
                    </SOPNode>
                    <SatNode>
                        <Saturation>\(String(format: "%.\(settingVariables.decimalPlaces)f", saturation))</Saturation>
                    </SatNode>
                </ColorCorrection>
                </ColorCorrectionCollection>
                """
        case "cdl":
            fileContent = """
                <?xml version="1.0" encoding="UTF-8"?>
                <ColorDecisionList xmlns="urn:ASC:CDL:v1.2">
                    <ColorDecision>
                        <ColorCorrection id="\(fileName)">
                            <SOPNode>
                                <Slope>\(String(format: "%.\(settingVariables.decimalPlaces)f", slope[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", slope[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", slope[2]))</Slope>
                                <Offset>\(String(format: "%.\(settingVariables.decimalPlaces)f", offset[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[2]))</Offset>
                                <Power>\(String(format: "%.\(settingVariables.decimalPlaces)f", power[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[2]))</Power>
                            </SOPNode>
                            <SatNode>
                                <Saturation>\(String(format: "%.\(settingVariables.decimalPlaces)f", saturation))</Saturation>
                            </SatNode>
                        </ColorCorrection>
                    </ColorDecision>
                </ColorDecisionList>
                """
        case "rcdl":
            fileContent = "\(String(format: "%.\(settingVariables.decimalPlaces)f", slope[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", slope[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", slope[2])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", offset[2])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[0])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[1])) \(String(format: "%.\(settingVariables.decimalPlaces)f", power[2])) \(String(format: "%.\(settingVariables.decimalPlaces)f", saturation))"
        default:
            fileContent = ""
        }
        return fileContent
    }
}
    

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewGenerateCDL()
    }
}
*/
