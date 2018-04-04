//
//  GameViewController.swift
//  Feed Test
//
//  Created by Kevin Colligan on 4/2/18.
//  Copyright © 2018 Kevin Colligan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

// MARK: - Model objects for my feed, which is @ https://www.mockhimup.com/tf-tweet-feed
// Had to use multiple for nested image

struct Response: Codable {
  let nodes: [Nodes]
}

struct Nodes: Codable {
  let node: Node
}

struct Node: Codable {
  let title: String
  let image: Image
  let id: String
}

struct Image: Codable {
  let src: String
  let alt: String?
}

class GameViewController: UIViewController {
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
 //  MARK: - Parsing code
      let jsonString = "https://www.mockhimup.com/tf-tweet-feed"
      guard let url = URL(string: jsonString) else { return }

      URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else { return }
        do {
          
          let decoder = JSONDecoder()
          let tweetData = try decoder.decode(Response.self, from: data)
         
          // Tammy: This prints out the response, so I seem to be getting data.  But now how do I pull out the images to add to an array?
          // In my intro, I want to pull a random image from that array, so users always see a fresh Trump tweet
          print(tweetData)
 

        } catch let jsonErr {
          print("Error serializing json", jsonErr)
        }

      }.resume()
   
      
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
  
  

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
