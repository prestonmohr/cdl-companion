//
//  ContentViewEDLConvert.swift
//  CDL Companion
//
//  Created by Preston Mohr on 1/29/23.
//

import SwiftUI
import Foundation

struct ContentViewEDLConvert: View {
    
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
    
    @State private var inputEDL: String = ""
    @State private var outputDirectory: String = ""
    @State private var outputFileType: String = ""
    @State private var edlFile: URL?
    @State private var outputDirectoryURL: URL?
    
    
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
                Text("Generate ASC CDLs from EDL")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .bold()
                Section {
                    HStack{
                        Text("Import CDL")
                            .font(.title2)
                            .frame(minWidth: 180, alignment: .leading)
                            .bold()
                            .padding(.trailing)
                        Button("Select File") {
                            // Open the system file picker to select a ccc, cc, or cdl file
                            let openPanel = NSOpenPanel()
                            openPanel.allowedFileTypes = ["edl"]
                            openPanel.begin { (result) in
                                if result == .OK {
                                    if let url = openPanel.url {
                                        self.edlFile = url
                                        self.inputEDL = url.lastPathComponent
                                    }
                                }
                            }
                        }
                        Text(self.inputEDL)
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
                                        self.outputDirectoryURL = openPanel.url
                                    }
                                }
                            }
                        TextField("Enter directory path", text: $outputDirectory)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            outputFileType = fileType[selectedFileTypeOut]
                            self.readEDL(edlFile: edlFile!, outputDirectory: outputDirectoryURL!, fileType: outputFileType)
                        }){
                            Text("Process EDL")
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
    
    func readEDL(edlFile: URL, outputDirectory: URL, fileType: String) {
        do {
            let fileContent = try String(contentsOf: edlFile, encoding: .utf8)
            let lines = fileContent.components(separatedBy: .newlines)
            settingVariables.decimalPlaces = 6
            setupDecimals()
            
            for line in lines {
                if line.hasPrefix("*FROM CLIP NAME:") {

                    let clipName = line.components(separatedBy: ":").last!.trimmingCharacters(in: .whitespaces)
                    
                    var sopLine = "*ASC_SOP (1.0 1.0 1.0)(0.0 0.0 0.0)(1.0 1.0 1.0)"
                    if (lines[lines.firstIndex(of: line)! + 1]).hasPrefix("*ASC_SOP"){
                        sopLine = lines[lines.firstIndex(of: line)! + 1]
                    }
                    else if (lines[lines.firstIndex(of: line)! + 2]).hasPrefix("*ASC_SOP"){
                        sopLine = lines[lines.firstIndex(of: line)! + 2]
                    }
                    else if (lines[lines.firstIndex(of: line)! + 3]).hasPrefix("*ASC_SOP"){
                        sopLine = lines[lines.firstIndex(of: line)! + 3]
                    }
                    else if (lines[lines.firstIndex(of: line)! + 4]).hasPrefix("*ASC_SOP"){
                        sopLine = lines[lines.firstIndex(of: line)! + 4]
                    }
                    else {
                        print("Cannot find ASC_SOP. Using default values.")
                    }
                    
                    var satLine = "*ASC_SAT 1.0"
                    
                    if (lines[lines.firstIndex(of: line)! + 2].hasPrefix("*ASC_SAT")) {
                        satLine = lines[lines.firstIndex(of: line)! + 2]
                    }
                    else if (lines[lines.firstIndex(of: line)! + 3].hasPrefix("*ASC_SAT")) {
                        satLine = lines[lines.firstIndex(of: line)! + 3]
                    }
                    else if (lines[lines.firstIndex(of: line)! + 4].hasPrefix("*ASC_SAT")) {
                        satLine = lines[lines.firstIndex(of: line)! + 4]
                    }
                    else if (lines[lines.firstIndex(of: line)! + 5].hasPrefix("*ASC_SAT")) {
                        satLine = lines[lines.firstIndex(of: line)! + 5]
                    }
                    else if (lines[lines.firstIndex(of: line)! + 6].hasPrefix("*ASC_SAT")) {
                        satLine = lines[lines.firstIndex(of: line)! + 6]
                    }
                    else {
                        print("Cannot find ASC_SAT. Using default values.")
                    }
                                        
                    let sopString = sopLine.components(separatedBy: " ").dropFirst().joined(separator: " ")
                    let sopArray = sopString.replacingOccurrences(of: "(", with: " ").replacingOccurrences(of: ")", with: " ").components(separatedBy: " ")
                    let sopValues = sopArray.filter { !$0.isEmpty }

                    let slope = sopValues[0...2].map { Double($0)! }
                    let offset = sopValues[3...5].map { Double($0)! }
                    let power = sopValues[6...8].map { Double($0)! }
                    
                    let satValue = Double(satLine.components(separatedBy: " ")[1])!
                    
                    let outputFileURL = outputDirectory.appendingPathComponent("\(clipName).\(fileType)")
                    let outputFileString = clipName
                    let fileContent = generateFileContent(fileName: outputFileString, slope: slope, offset: offset, power: power, saturation: satValue, fileType: fileType)
                    //print(fileContent)
                    
                    print("Outputted to file: " + outputFileString +  "." + fileType)
                    do {
                        try fileContent.write(to: outputFileURL, atomically: true, encoding: .utf8)
                    } catch {
                        print("Failed to write file")
                    }
                }
            }
        }
        catch{
            print("Failed to read EDL")
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
