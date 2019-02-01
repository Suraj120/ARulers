//
//  ViewController.swift
//  ARulers
//
//  Created by TejaSwaroop on 16/01/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    var allX = [Double]()
    var allY = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches detected")
        
        print("number of nodes \(dotNodes.count)")
        
        if dotNodes.count >= 4 {
            for dot in dotNodes {
                //dot.removeFromParentNode()
            }
            //dotNodes = [SCNNode]()
        }
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                
                addDot(at: hitResult)
            }
            
        }
        
    }
    
    func addDot(at hitResult: ARHitTestResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        calculateCoordinates()
        if dotNodes.count == 2 {
            calculate()
            
        }else  if dotNodes.count >= 3 {
            poygonArea(X: allX, Y: allY, points: dotNodes.count)
        }
        drawLines()
        
    }
    
    
    
    func calculateCoordinates() {
        allX.removeAll()
        allY.removeAll()
        for val in dotNodes {
            
            allY.append(Double(val.position.y))
            allX.append(Double(val.position.x))
    }
         print("x values \(allX)")
        print("y values \(allY)")
        
       
        
    }
    
    
        func calculate (){
            
    let start = dotNodes[0]
    let end = dotNodes[1]
    
    print(start.position)
    print(end.position)
    
    //distance in 3D space using pythogoras theorem!!!
    
    let a = end.position.x - start.position.x
    let b = end.position.y - start.position.y
    let c = end.position.z - start.position.z
    
    let distance = abs(sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2)))
    print("distance in space \(distance)")
    
    updateText(text: "\(distance)", atPosition: end.position)
    
    

    
   
    
}
    
    
    
    func drawLines() {
        
        for i in 0...dotNodes.count-1 {
            
            var lines : SCNNode = SCNNode()
            if i == dotNodes.count-1 {
                lines = line(startPoint: dotNodes[i].position, endPoint: dotNodes[0].position, color: UIColor.yellow)
                
            }
            else {
                lines = line(startPoint: dotNodes[i].position, endPoint: dotNodes[i+1].position, color: UIColor.yellow)
            }
            
            sceneView.scene.rootNode.addChildNode(lines)
            
            
        }
        
        
        
    }
    
    func line(startPoint: SCNVector3, endPoint: SCNVector3, color : UIColor) -> SCNNode
    {
        let vertices: [SCNVector3] = [startPoint, endPoint]
        let data = NSData(bytes: vertices, length: MemoryLayout<SCNVector3>.size * vertices.count) as Data
        
        let vertexSource = SCNGeometrySource(data: data,
                                             semantic: .vertex,
                                             vectorCount: vertices.count,
                                             usesFloatComponents: true,
                                             componentsPerVector: 3,
                                             bytesPerComponent: MemoryLayout<Float>.size,
                                             dataOffset: 0,
                                             dataStride: MemoryLayout<SCNVector3>.stride)
        
        
        let indices: [Int32] = [ 0, 1]
        
        let indexData = NSData(bytes: indices, length: MemoryLayout<Int32>.size * indices.count) as Data
        
        let element = SCNGeometryElement(data: indexData,
                                         primitiveType: .line,
                                         primitiveCount: indices.count/2,
                                         bytesPerIndex: MemoryLayout<Int32>.size)
        
        let line = SCNGeometry(sources: [vertexSource], elements: [element])
        
        line.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        line.firstMaterial?.diffuse.contents = color
        
        let lineNode = SCNNode(geometry: line)
        return lineNode;
    }
    
    
    
    
    func updateText(text: String, atPosition position:SCNVector3) {
        
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.green
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3Make(position.x, position.y + 0.01, position.z)
        textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        sceneView.scene.rootNode.addChildNode(textNode)
        
        
    }
    
    
    
    func poygonArea( X arrX:[Double], Y arrY:[Double], points totalPoints:Int) -> Double {
        
        let end = dotNodes[dotNodes.count-1]
        var area = 0.0
        var j = totalPoints-1
        for val in 0..<totalPoints {
            area = area + (arrX[j] + arrX[val]) * (arrY[j] - arrY[val])
            j=val
        }
        print("area is \(area/2.0)")
         updateText(text: "\(area/2)", atPosition:end.position )
        
        return area/2.0
}

}






