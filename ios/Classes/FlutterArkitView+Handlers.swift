import ARKit
import SwiftUI

extension SKScene {
    static func fromBundle(fileName: String, bundle: Bundle?) -> SKScene? {
        guard let bundle = bundle else { return nil }
        guard let path = bundle.path(forResource: fileName, ofType: "sks") else { return nil }
        if let data = FileManager.default.contents(atPath: path) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? SKScene
        }
        return nil
    }
}

extension FlutterArkitView {
    func onAddNode(_ arguments: Dictionary<String, Any>) {
        let geometryArguments = arguments["geometry"] as? Dictionary<String, Any>
        let geometry = createGeometry(geometryArguments, withDevice: sceneView.device)
        let node = createNode(geometry, fromDict: arguments, forDevice: sceneView.device)
        if let parentNodeName = arguments["parentNodeName"] as? String {
            let parentNode = sceneView.scene.rootNode.childNode(withName: parentNodeName, recursively: true)
            parentNode?.addChildNode(node)
        } else {
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func onAddUIViewNode(_ arguments: Dictionary<String, Any>) {
        
        let planeNode = SCNPlane(width: 1, height: 1)// createGeometry(geometryArguments, withDevice: sceneView.device)
        
        let node = createUINode(planeNode, fromDict: arguments, forDevice: sceneView.device)
        
        createSKCard(for: node, args: arguments)
    }
    
    func createSKCard(for node: SCNNode,  args: Dictionary<String, Any>) {
        let material = SCNMaterial()
        material.diffuse.contents = createUI2(args: args)
        material.isDoubleSided = true
        
        node.geometry?.materials = [material]
        
        node.localRotate(by: SCNQuaternion(0, 0, Float.pi, 0))
        
        self.sceneView.scene.rootNode.addChildNode(node)
        node.look(at: SCNVector3Zero)
    }
    
    func createUI2(args: Dictionary<String, Any>) -> SKScene {

        let podBundle = Bundle(for: FlutterArkitView.self)
        let url = podBundle.url(forResource: "arkit_plugin", withExtension: "bundle")
        let bundle = Bundle(url: url!)
        let skScene = SKScene.fromBundle(fileName: "SKPostCard", bundle: bundle)!
        
        
        let textImg = UIImage(named: "post_card_texture_ios", in: bundle, compatibleWith: nil)
        let nodeTexture = SKTexture(image: textImg!)

        skScene.backgroundColor = .clear
        let backgroundNode = skScene.childNode(withName: "backgroundNode") as? SKSpriteNode
        backgroundNode?.texture = nodeTexture
        
        // load author
        let author = args["username"] as? String ?? "No username"
        let authorLabel = backgroundNode?.childNode(withName: "authorLabel") as? SKLabelNode
        let mutableAttributedText = authorLabel?.attributedText?.mutableCopy()
        (mutableAttributedText as? NSMutableAttributedString)?.mutableString.setString(author)
        authorLabel?.attributedText = mutableAttributedText! as? NSAttributedString


        
        if let postType = args["type"] as? String {

            let imageContent = backgroundNode?.childNode(withName: "postContent")?.childNode(withName: "imageContent") as? SKSpriteNode

            let textContent = backgroundNode?.childNode(withName: "postContent")?.childNode(withName: "textContent") as? SKLabelNode
            
            if postType == "TEXT" {
                imageContent?.isHidden = true
                textContent?.isHidden = false
            } else {
                // IMAGE
                imageContent?.isHidden = false
                textContent?.isHidden = true
            }

            if postType == "TEXT" {
                // text content
                
                let mutableAttributedText = textContent?.attributedText?.mutableCopy()
                (mutableAttributedText as? NSMutableAttributedString)?.mutableString.setString(args["raw"] as? String ?? "No Content :c")
                
                
                textContent?.preferredMaxLayoutWidth = (backgroundNode?.size.width)! - 50.0
                textContent?.attributedText = mutableAttributedText! as? NSAttributedString

            } else {
                UIImage.downloadImage(from: NSURL(string: args["raw"] as! String)! as URL, onNewImage: {
                    (rawImage) in
                    let imgTex = SKTexture(image: rawImage!)
                    imageContent?.texture = imgTex
                })
            }
        }

        
        // load icons
        let statsGroup = backgroundNode?.childNode(withName: "StatsGroup")
        
        let viewIcon = statsGroup?.childNode(withName: "viewIcon") as? SKSpriteNode
        let viewTexImage = UIImage(named: "eye_1", in: bundle, compatibleWith: nil)
        let viewTex = SKTexture(image: viewTexImage!)
        viewIcon?.texture = viewTex
        
        let likeIcon = statsGroup?.childNode(withName: "likeIcon") as? SKSpriteNode
        let likeTexImage = UIImage(named: "heart_1", in: bundle, compatibleWith: nil)
        let likeTex = SKTexture(image: likeTexImage!)
        likeIcon?.texture = likeTex
        
        // load stats value
        
        if let likes = args["likes"] as? Int {
            let likeLabel = statsGroup?.childNode(withName: "likeLabel") as? SKLabelNode
            likeLabel?.text = String(format: "%02d", likes)
        }
        
        if let views = args["views"] as? Int {
            let viewsLabel = statsGroup?.childNode(withName: "viewLabel") as? SKLabelNode
            viewsLabel?.text = String(format: "%02d", views)
        }
        
        return skScene
    }

    
    func onRemoveNode(_ arguments: Dictionary<String, Any>) {
        guard let nodeName = arguments["nodeName"] as? String else {
            logPluginError("nodeName deserialization failed", toChannel: channel)
            return
        }
        let node = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
        node?.removeFromParentNode()
    }
  
    func onRemoveAnchor(_ arguments: Dictionary<String, Any>) {
        guard let anchorIdentifier = arguments["anchorIdentifier"] as? String else {
            logPluginError("anchorIdentifier deserialization failed", toChannel: channel)
            return
        }
        if let anchor = sceneView.session.currentFrame?.anchors.first(where:{ $0.identifier.uuidString == anchorIdentifier }) {
            sceneView.session.remove(anchor: anchor)
        }
    }
    
    func onGetNodeBoundingBox(_ arguments: Dictionary<String, Any>, _ result:FlutterResult) {
        guard let geometryArguments = arguments["geometry"] as? Dictionary<String, Any> else {
            logPluginError("geometryArguments deserialization failed", toChannel: channel)
            result(nil)
            return
        }
        let geometry = createGeometry(geometryArguments, withDevice: sceneView.device)
        let node = createNode(geometry, fromDict: arguments, forDevice: sceneView.device)
        
        let resArray = [serializeVector(node.boundingBox.min), serializeVector(node.boundingBox.max)]
        result(resArray)
    }
    
    func onTransformChanged(_ arguments: Dictionary<String, Any>) {
        guard let name = arguments["name"] as? String,
            let params = arguments["transformation"] as? Array<NSNumber>
            else {
                logPluginError("deserialization failed", toChannel: channel)
                return
        }
        if let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true) {
            node.transform = deserializeMatrix4(params)
        } else {
            logPluginError("node not found", toChannel: channel)
        }
    }
    
    func onIsHiddenChanged(_ arguments: Dictionary<String, Any>) {
        guard let name = arguments["name"] as? String,
            let params = arguments["isHidden"] as? Bool
            else {
                logPluginError("deserialization failed", toChannel: channel)
                return
        }
        if let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true) {
            node.isHidden = params
        } else {
            logPluginError("node not found", toChannel: channel)
        }
    }
    
    func onUpdateSingleProperty(_ arguments: Dictionary<String, Any>) {
        guard let name = arguments["name"] as? String,
            let args = arguments["property"] as? Dictionary<String, Any>,
            let propertyName = args["propertyName"] as? String,
            let propertyValue = args["propertyValue"],
            let keyProperty = args["keyProperty"] as? String
            else {
                logPluginError("deserialization failed", toChannel: channel)
                return
        }
        
        if let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true) {
            if let obj = node.value(forKey: keyProperty) as? NSObject {
                obj.setValue(propertyValue, forKey: propertyName)
            } else {
                logPluginError("value is not a NSObject", toChannel: channel)
            }
        } else {
            logPluginError("node not found", toChannel: channel)
        }
    }
    
    func onUpdateMaterials(_ arguments: Dictionary<String, Any>) {
        guard let name = arguments["name"] as? String,
            let rawMaterials = arguments["materials"] as? Array<Dictionary<String, Any>>
            else {
                logPluginError("deserialization failed", toChannel: channel)
                return
        }
        if let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true) {
            
            let materials = parseMaterials(rawMaterials)
            node.geometry?.materials = materials
        } else {
            logPluginError("node not found", toChannel: channel)
        }
    }
    
    func onUpdateFaceGeometry(_ arguments: Dictionary<String, Any>) {
        #if !DISABLE_TRUEDEPTH_API
        guard let name = arguments["name"] as? String,
            let param = arguments["geometry"] as? Dictionary<String, Any>,
            let fromAnchorId = param["fromAnchorId"] as? String
            else {
                logPluginError("deserialization failed", toChannel: channel)
                return
        }
        if let node = sceneView.scene.rootNode.childNode(withName: name, recursively: true),
            let geometry = node.geometry as? ARSCNFaceGeometry,
            let anchor = sceneView.session.currentFrame?.anchors.first(where: {$0.identifier.uuidString == fromAnchorId}) as? ARFaceAnchor
        {
            
            geometry.update(from: anchor.geometry)
        } else {
            logPluginError("node not found, geometry was empty, or anchor not found", toChannel: channel)
        }
        #else
        logPluginError("TRUEDEPTH_API disabled", toChannel: channel)
        #endif
    }
    
    func onPerformHitTest(_ arguments: Dictionary<String, Any>, _ result:FlutterResult) {
        guard let x = arguments["x"] as? Double,
            let y = arguments["y"] as? Double else {
                logPluginError("deserialization failed", toChannel: channel)
                result(nil)
                return
        }
        let viewWidth = sceneView.bounds.size.width
        let viewHeight = sceneView.bounds.size.height
        let location = CGPoint(x: viewWidth * CGFloat(x), y: viewHeight * CGFloat(y));
        let arHitResults = getARHitResultsArray(sceneView, atLocation: location)
        result(arHitResults)
    }
    
    func onGetLightEstimate(_ result:FlutterResult) {
        let frame = sceneView.session.currentFrame
        if let lightEstimate = frame?.lightEstimate {
            let res = ["ambientIntensity": lightEstimate.ambientIntensity, "ambientColorTemperature": lightEstimate.ambientColorTemperature]
            result(res)
        } else {
            result(nil)
        }
    }
    
    func onProjectPoint(_ arguments: Dictionary<String, Any>, _ result:FlutterResult) {
        guard let rawPoint = arguments["point"] as? Array<Double> else {
            logPluginError("deserialization failed", toChannel: channel)
            result(nil)
            return
        }
        let point = deserizlieVector3(rawPoint)
        let projectedPoint = sceneView.projectPoint(point)
        let res = serializeVector(projectedPoint)
        result(res)
    }
    
    func onCameraProjectionMatrix(_ result:FlutterResult) {
        if let frame = sceneView.session.currentFrame {
            let matrix = serializeMatrix(frame.camera.projectionMatrix)
            result(matrix)
        } else {
            result(nil)
        }
    }
  
    func onPointOfViewTransform(_ result:FlutterResult) {
        if let pointOfView = sceneView.pointOfView {
          let matrix = serializeMatrix(pointOfView.simdWorldTransform)
            result(matrix)
        } else {
            result(nil)
        }
    }
    
    func onPlayAnimation(_ arguments: Dictionary<String, Any>) {
        guard let key = arguments["key"] as? String,
            let sceneName = arguments["sceneName"] as? String,
            let animationIdentifier = arguments["animationIdentifier"] as? String else {
                logPluginError("deserialization failed", toChannel: channel)
                return
        }
        
        if let sceneUrl = Bundle.main.url(forResource: sceneName, withExtension: "dae"),
            let sceneSource = SCNSceneSource(url: sceneUrl, options: nil),
            let animation = sceneSource.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            animation.repeatCount = 1
            animation.fadeInDuration = 1
            animation.fadeOutDuration = 0.5
            sceneView.scene.rootNode.addAnimation(animation, forKey: key)
        } else {
            logPluginError("animation failed", toChannel: channel)
        }
    }
    
    func onStopAnimation(_ arguments: Dictionary<String, Any>) {
        guard let key = arguments["key"] as? String else {
            logPluginError("deserialization failed", toChannel: channel)
            return
        }
        sceneView.scene.rootNode.removeAnimation(forKey: key)
    }
}
