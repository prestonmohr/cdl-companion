//
//  ContentView.swift
//  CDL-convert
//
//  Created by Preston Mohr on 1/27/23.
//

import SwiftUI
import Foundation

struct ContentViewConvertCDL: View {
    
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
    @State private var fileURL: URL?
    @State private var currentElementName: String? = nil
    
    //number formatter for slope values : 0 <= slope < 4
    @State private var numberFormatterSlope = settingVariables.numberFormatterSlope
    //number formatter for offset values : -1 < offset < 1
    @State private var numberFormatterOffset = settingVariables.numberFormatterOffset
    //number formatter for power values : 0.5 <= power <= 2
    @State private var numberFormatterPower = settingVariables.numberFormatterPower
    //number formatter for saturation value : 0 <= saturation < 2
    @State private var numberFormatterSaturation = settingVariables.numberFormatterSaturation
    
    init(){
        setupDecimals()
    }
    
    var body: some View {
        ScrollView {
            Section {
                Text("Convert ASC CDL")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .bold()
                Section {
                    HStack{
                        Text("Import CDL")
                            .font(.title2)
                            .frame(minWidth: 125, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        
                        Button("Select File") {
                            // Open the system file picker to select a ccc, cc, or cdl file
                            let openPanel = NSOpenPanel()
                            openPanel.allowedFileTypes = ["ccc", "cc", "cdl", "rcdl"]
                            openPanel.begin { (result) in
                                if result == .OK {
                                    if let url = openPanel.url {
                                        if (url.pathExtension == "ccc" || url.pathExtension == "cc" || url.pathExtension == "cdl")  {
                                            self.readValuesFromFile(url: url)
                                        }
                                        else if (url.pathExtension == "rcdl"){
                                            self.readValuesFromRCDL(url: url)
                                        }
                                        else {
                                            print("Filetype error.")
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section {
                    HStack{
                        Text("CDL Name")
                            .font(.title3)
                            .frame(minWidth: 125, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        TextField("Enter file name", text: $fileName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section{
                    HStack{
                        Text("Slope")
                            .font(.title3)
                            .frame(minWidth: 125, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        HStack{
                            TextField("Enter slope value for red channel", value: $slopeR, formatter: numberFormatterSlope)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Enter slope value for green channel", value: $slopeG, formatter: numberFormatterSlope)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Enter slope value for blue channel", value: $slopeB, formatter: numberFormatterSlope)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section{
                    HStack{
                        Text("Offset")
                            .font(.title3)
                            .frame(minWidth: 125, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        HStack{
                            TextField("Enter offset value for red channel", value: $offsetR, formatter: numberFormatterOffset)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Enter offset value for green channel", value: $offsetG, formatter: numberFormatterOffset)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Enter offset value for blue channel", value: $offsetB, formatter: numberFormatterOffset)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section {
                    HStack {
                        Text("Power")
                            .font(.title3)
                            .frame(minWidth: 125, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        HStack {
                            TextField("Enter power value for red channel", value: $powerR, formatter: numberFormatterPower)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Enter power value for green channel", value: $powerG, formatter: numberFormatterPower)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Enter power value for blue channel", value: $powerB, formatter: numberFormatterPower)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section {
                    HStack {
                        Text("Saturation")
                            .font(.title3)
                            .frame(minWidth: 125, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        TextField("Enter saturation value", value: $saturation, formatter: numberFormatterSaturation)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Section {
                    HStack {
                        Text("Filetype")
                            .font(.title3)
                            .frame(minWidth: 118, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        Picker(selection: $selectedFileType, label: Text("")) {
                            ForEach(0..<fileType.count) {
                                Text(self.fileType[$0])
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Section {
                    HStack {
                        Text("Export CDL")
                            .font(.title2)
                            .frame(minWidth: 125, alignment: .leading)
                            .bold()
                            .padding(.trailing)
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
    
    func readValuesFromFile(url: URL) {
        do {
            let xmlString = try String(contentsOf: url)
            let xmlDoc = try XMLDocument(xmlString: xmlString)
            let rootElement = xmlDoc.rootElement()
            
            if rootElement?.name == "ColorCorrectionCollection" {
                // read ccc file
                let colorCorrection = rootElement?.elements(forName: "ColorCorrection").first
                let id = colorCorrection?.attribute(forName: "id")?.stringValue
                let sopNode = colorCorrection?.elements(forName: "SOPNode").first
                let slope = sopNode?.elements(forName: "Slope").first?.stringValue
                let offset = sopNode?.elements(forName: "Offset").first?.stringValue
                let power = sopNode?.elements(forName: "Power").first?.stringValue
                let satNode = colorCorrection?.elements(forName: "SatNode").first
                let saturation = satNode?.elements(forName: "Saturation").first?.stringValue
                
                //determine number of decimal places
                //set decimal places to length of first slope RGB value
                settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[0] ?? "0.0000").count-2)
                
                //check length of each slope RGB value
                if (Int((slope?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((slope?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[2] ?? "0.0000").count-2)
                }
                
                let absTestR = (offset?.components(separatedBy: " ")[0] ?? "0.0000").prefix(1) == "-"
                let absTestG = (offset?.components(separatedBy: " ")[1] ?? "0.0000").prefix(1) == "-"
                let absTestB = (offset?.components(separatedBy: " ")[2] ?? "0.0000").prefix(1) == "-"
                
                //check length of each offset RGB value
                if (absTestR && Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-2)
                }
                if (absTestG && Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (absTestB && Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-2)
                }
                
                //check length of each power RGB value
                if (Int((power?.components(separatedBy: " ")[0] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((power?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                
                //check length of saturation value
                if (Int((saturation ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((saturation ?? "0.0000").count-2)
                }
                
                setupDecimals()
                
                // set the contentview variables to the values read from the file
                self.fileName = id ?? ""
                self.slopeR = Double(slope?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.slopeG = Double(slope?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.slopeB = Double(slope?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.offsetR = Double(offset?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.offsetG = Double(offset?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.offsetB = Double(offset?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.powerR = Double(power?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.powerG = Double(power?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.powerB = Double(power?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.saturation = Double(saturation ?? "0") ?? 0
                
            } else if rootElement?.name == "ColorCorrection" {
                // read cc file
                let id = rootElement?.attribute(forName: "id")?.stringValue
                let sopNode = rootElement?.elements(forName: "SOPNode").first
                let slope = sopNode?.elements(forName: "Slope").first?.stringValue
                let offset = sopNode?.elements(forName: "Offset").first?.stringValue
                let power = sopNode?.elements(forName: "Power").first?.stringValue
                let satNode = rootElement?.elements(forName: "SatNode").first
                let saturation = satNode?.elements(forName: "Saturation").first?.stringValue
                
                //determine number of decimal places
                //set decimal places to length of first slope RGB value
                settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[0] ?? "0.0000").count-2)
                
                //check length of each slope RGB value
                if (Int((slope?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((slope?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[2] ?? "0.0000").count-2)
                }
                
                let absTestR = (offset?.components(separatedBy: " ")[0] ?? "0.0000").prefix(1) == "-"
                let absTestG = (offset?.components(separatedBy: " ")[1] ?? "0.0000").prefix(1) == "-"
                let absTestB = (offset?.components(separatedBy: " ")[2] ?? "0.0000").prefix(1) == "-"
                
                //check length of each offset RGB value
                if (absTestR && Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-2)
                }
                if (absTestG && Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (absTestB && Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-2)
                }
                
                //check length of each power RGB value
                if (Int((power?.components(separatedBy: " ")[0] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((power?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                
                //check length of saturation value
                if (Int((saturation ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((saturation ?? "0.0000").count-2)
                }
                
                setupDecimals()
                
                // set the contentview variables to the values read from the file
                self.fileName = id ?? ""
                self.slopeR = Double(slope?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.slopeG = Double(slope?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.slopeB = Double(slope?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.offsetR = Double(offset?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.offsetG = Double(offset?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.offsetB = Double(offset?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.powerR = Double(power?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.powerG = Double(power?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.powerB = Double(power?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.saturation = Double(saturation ?? "0") ?? 0
                
            } else if rootElement?.name == "ColorDecisionList" {
                let colorDecision = rootElement?.elements(forName: "ColorDecision").first
                let colorCorrection = colorDecision?.elements(forName: "ColorCorrection").first
                let id = colorCorrection?.attribute(forName: "id")?.stringValue
                let sopNode = colorCorrection?.elements(forName: "SOPNode").first
                let slope = sopNode?.elements(forName: "Slope").first?.stringValue
                let offset = sopNode?.elements(forName: "Offset").first?.stringValue
                let power = sopNode?.elements(forName: "Power").first?.stringValue
                let satNode = colorCorrection?.elements(forName: "SatNode").first
                let saturation = satNode?.elements(forName: "Saturation").first?.stringValue
                
                //determine number of decimal places
                //set decimal places to length of first slope RGB value
                settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[0] ?? "0.0000").count-2)
                
                //check length of each slope RGB value
                if (Int((slope?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((slope?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((slope?.components(separatedBy: " ")[2] ?? "0.0000").count-2)
                }
                
                let absTestR = (offset?.components(separatedBy: " ")[0] ?? "0.0000").prefix(1) == "-"
                let absTestG = (offset?.components(separatedBy: " ")[1] ?? "0.0000").prefix(1) == "-"
                let absTestB = (offset?.components(separatedBy: " ")[2] ?? "0.0000").prefix(1) == "-"
                
                //check length of each offset RGB value
                if (absTestR && Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[0] ?? "0.0000").count-2)
                }
                if (absTestG && Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (absTestB && Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-3) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-3)
                }
                if (!(absTestR) && Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((offset?.components(separatedBy: " ")[2] ?? "0.0000").count-2)
                }
                
                //check length of each power RGB value
                if (Int((power?.components(separatedBy: " ")[0] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                if (Int((power?.components(separatedBy: " ")[2] ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((power?.components(separatedBy: " ")[1] ?? "0.0000").count-2)
                }
                
                //check length of saturation value
                if (Int((saturation ?? "0.0000").count-2) > settingVariables.decimalPlaces) {
                    settingVariables.decimalPlaces = Int((saturation ?? "0.0000").count-2)
                }
                
                setupDecimals()
                
                // set the contentview variables to the values read from the file
                self.fileName = id ?? ""
                self.slopeR = Double(slope?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.slopeG = Double(slope?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.slopeB = Double(slope?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.offsetR = Double(offset?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.offsetG = Double(offset?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.offsetB = Double(offset?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.powerR = Double(power?.components(separatedBy: " ")[0] ?? "0") ?? 0
                self.powerG = Double(power?.components(separatedBy: " ")[1] ?? "0") ?? 0
                self.powerB = Double(power?.components(separatedBy: " ")[2] ?? "0") ?? 0
                self.saturation = Double(saturation ?? "0") ?? 0
            } else {
                print("Unable to parse cc, ccc, or cdl file")
            }

        } catch {
            print("Failed to read file: \(error.localizedDescription)")
        }
    }
    
    func readValuesFromRCDL(url: URL) {
        do {
            let fileContent = try String(contentsOf: url)
            let values = fileContent.split(separator: " ")
            
            guard values.count == 10 else {
                print("Error: Invalid RCDL file")
                return
            }
            
            //determine number of decimal places
            //set decimal places to length of first slope RGB value
            settingVariables.decimalPlaces = Int((values[0]).count-2)
            
            //check length of each slope RGB value
            if (Int((values[1]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[1]).count-2)
            }
            if (Int((values[2]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[2]).count-2)
            }
            
            let absTestR = (values[3]).prefix(1) == "-"
            let absTestG = (values[4]).prefix(1) == "-"
            let absTestB = (values[5]).prefix(1) == "-"
            
            //check length of each offset RGB value
            if (absTestR && Int((values[3]).count-3) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[3]).count-3)
            }
             
            if (!(absTestR) && Int((values[3]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[3]).count-2)
            }
            if (absTestG && Int((values[4]).count-3) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[4]).count-3)
            }
            if (!(absTestR) && Int((values[4]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[4]).count-2)
            }
            if (absTestB && Int((values[5]).count-3) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[5]).count-3)
            }
            if (!(absTestR) && Int((values[5]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[5]).count-2)
            }
            
            //check length of each power RGB value
            if (Int((values[6]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[6]).count-2)
            }
            if (Int((values[7]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[7]).count-2)
            }
            if (Int((values[8]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[8]).count-2)
            }
            
            //check length of saturation value
            if (Int((values[9]).count-2) > settingVariables.decimalPlaces) {
                settingVariables.decimalPlaces = Int((values[9]).count-2)
            }
            
            setupDecimals()
            
            self.slopeR = Double(values[0])!
            self.slopeG = Double(values[1])!
            self.slopeB = Double(values[2])!
            self.offsetR = Double(values[3])!
            self.offsetG = Double(values[4])!
            self.offsetB = Double(values[5])!
            self.powerR = Double(values[6])!
            self.powerG = Double(values[7])!
            self.powerB = Double(values[8])!
            self.saturation = Double(values[9])!
            
            let rcdlFileName = url.lastPathComponent
            let i = rcdlFileName.lastIndex(of: ".")
            self.fileName = String(rcdlFileName.prefix(upTo: i!))
             
        } catch {
            print("Error reading RCDL file: \(error)")
        }
    }

}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewGenerateCDL()
    }
}
*/
