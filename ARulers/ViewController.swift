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
        
//        if dotNodes.count >= 5 {
//            for dot in dotNodes {
//                dot.removeFromParentNode()
//            }
//            dotNodes = [SCNNode]()
//        }
        
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
        
        //dotNode.position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, 0.0)
        
        
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 4 {
            calculateCoordinates()
        }
    }
    
    var allX = [Float]()
    var allY = [Float]()
    func calculateCoordinates() {
        
        for val in dotNodes {
            
            allY.append(val.position.y)
            allX.append(val.position.x)
            print("coordinates\(val)")
    }
        print("y values \(allY)")
        print("x values \(allX)")
        
    }
    
    
//    func calculate (){
//        let start = dotNodes[0]
//        let end = dotNodes[1]
//        //let end = dotNodes[dotNodes.count - 1]
//
//        for val in dotNodes.enumerated() {
//            print("coordinates\(val)")
//        }
//
//        print(start.position)
//        print(end.position)
//
//        //distance in 3D space using pythogoras theorem!!!
//
//        let a = end.position.x - start.position.x
//        let b = end.position.y - start.position.y
//        let c = end.position.z - start.position.z
//
//        let distance = abs(sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2)))
//        print("distance in space \(distance)")
//
//        updateText(text: "\(distance)", atPosition: end.position)
//
//
//    }
    
    func updateText(text: String, atPosition position:SCNVector3) {
        
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.green
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3Make(position.x, position.y + 0.01, position.z)
        textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        sceneView.scene.rootNode.addChildNode(textNode)
        
        
    }
    
}

//X, Y    Arrays of the x and y coordinates of the vertices, traced in a clockwise direction, starting at any vertex. If you trace them counterclockwise, the result will be correct but have a negative sign.
//numPoints    The number of vertices
//Returns    the area of the polygon



//function polygonArea(X, Y, numPoints)
//{
//    area = 0;         // Accumulates area in the loop
//    j = numPoints-1;  // The last vertex is the 'previous' one to the first
//
//    for (i=0; i<numPoints; i++)
//    { area = area +  (X[j]+X[i]) * (Y[j]-Y[i]);
//        j = i;  //j is previous vertex to i
//    }
//    return area/2;
//}








