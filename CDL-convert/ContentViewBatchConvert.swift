//
//  ContentViewBatchConvert.swift
//  CDL Companion
//
//  Created by Preston Mohr on 1/28/23.
//

import SwiftUI
import Foundation

struct ContentViewBatchConvert: View {
    
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
    @State private var selectedFileTypeOut = 0
    @State private var fileType = ["cc", "ccc", "cdl", "rcdl"]
    @State private var fileName: String = ""
    @State private var showSavePanel = false
    @State private var selectedURL: URL? = nil
    @State private var fileURL: URL?
    @State private var currentElementName: String? = nil
    
    @State private var inputDirectory: String = ""
    @State private var outputDirectory: String = ""
    @State private var inputFileType: String = ""
    @State private var outputFileType: String = ""
    
    
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
                Text("Batch Convert ASC CDLs")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .bold()
                Section {
                    HStack{
                        Text("Input CDL Directory")
                            .font(.title2)
                            .frame(minWidth: 180, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        Image(systemName: "folder")
                            .onTapGesture {
                                let openPanel = NSOpenPanel()
                                openPanel.canChooseDirectories = true
                                openPanel.canChooseFiles = false
                                openPanel.begin { (result) in
                                    if result == .OK {
                                        self.inputDirectory = openPanel.url!.path
                                    }
                                }
                            }
                        TextField("Enter directory path", text: $inputDirectory)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section {
                    HStack {
                        Text("Input Filetype")
                            .font(.title3)
                            .frame(minWidth: 172, alignment: .leading)
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
                        Text("Output Filetype")
                            .font(.title3)
                            .frame(minWidth: 172, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        Picker(selection: $selectedFileTypeOut, label: Text("")) {
                            ForEach(0..<fileType.count) {
                                Text(self.fileType[$0])
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section {
                    HStack {
                        Text("Output CDL Directory")
                            .font(.title2)
                            .frame(minWidth: 180, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        
                        Image(systemName: "folder")
                            .onTapGesture {
                                let openPanel = NSOpenPanel()
                                openPanel.canChooseDirectories = true
                                openPanel.canChooseFiles = false
                                openPanel.begin { (result) in
                                    if result == .OK {
                                        self.outputDirectory = openPanel.url!.path
                                    }
                                }
                            }
                        TextField("Enter directory path", text: $outputDirectory)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            inputFileType = fileType[selectedFileType]
                            outputFileType = fileType[selectedFileTypeOut]
                            self.convertFiles(inputDirectory: self.inputDirectory, outputDirectory: self.outputDirectory, inputFileType: self.inputFileType, outputFileType: self.outputFileType)
                        }){
                            Text("Batch Convert")
                        }
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
        let fileType = self.fileType[selectedFileTypeOut]
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
                print("Unable to parse cc or ccc file")
            }

        } catch {
            print("Failed to read file: \(error.localizedDescription)")
        }
    }
    
    func convertFiles(inputDirectory: String, outputDirectory: String, inputFileType: String, outputFileType: String) {
        let inputURL = URL(fileURLWithPath: inputDirectory)
        let outputURL = URL(fileURLWithPath: outputDirectory)
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: inputURL, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if fileURL.pathExtension == inputFileType {
                    if (fileURL.pathExtension == "ccc" || fileURL.pathExtension == "cc" || fileURL.pathExtension == "cdl")  {
                        self.readValuesFromFile(url: fileURL)
                    }
                    else if (fileURL.pathExtension == "rcdl"){
                        self.readValuesFromRCDL(url: fileURL)
                    }
                    else {
                        print("Filetype error.")
                    }
                    var outputFileURL = outputURL.appendingPathComponent(fileURL.lastPathComponent)
                    outputFileURL.deletePathExtension()
                    outputFileURL.appendPathExtension(outputFileType)
                    generateFile(url: outputFileURL)
                }
                else{
                    continue
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
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
        ContentViewBatchConvert()
    }
}
*/
