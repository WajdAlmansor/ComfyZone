import SpriteKit

class WinScene: SKScene {
    var backgroundMusic: SKAudioNode?
    
    override func didMove(to view: SKView) {
        addBackgrounds()  
        addGirl()        
        startBackgroundTransition() 
        playBackgroundMusic()
        debugZPositions() 
    }
    
    func debugZPositions() {
        self.enumerateChildNodes(withName: "*") { node, _ in
            print("Node: \(node.name ?? "Unnamed"), zPosition: \(node.zPosition)")
        }
    }
    
    func addBackgrounds() {
    
        let background3 = SKSpriteNode(imageNamed: "Background3")
        background3.size = self.size
        background3.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background3.zPosition = 0
        
        self.addChild(background3)
        
    
        let background4 = SKSpriteNode(imageNamed: "Background4")
        background4.size = self.size
        background4.position = CGPoint(x: self.size.width / 2, y: self.size.height * 1.5) 
        background4.zPosition = 1
        
        self.addChild(background4)
        
        background3.name = "Background3"
        background4.name = "Background4"
    }
    
    func addGirl() {
        let girl = SKSpriteNode(imageNamed: "Girl")
        girl.setScale(1) 
        girl.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        girl.zPosition = 2 
        
        self.addChild(girl)
    }
    
    func startBackgroundTransition() {
        
        guard let background3 = self.childNode(withName: "Background3") as? SKSpriteNode,
              let background4 = self.childNode(withName: "Background4") as? SKSpriteNode else { return }
        
        let moveDown = SKAction.moveBy(x: 0, y: -self.size.height, duration: 2.0) 
        let showWinElements = SKAction.run {
            self.addWinMessage()
            self.addButtons()
        }
        
        let sequence = SKAction.sequence([moveDown, showWinElements])
        
        background3.run(sequence)
        background4.run(sequence)
    }
    
    func addWinMessage() {
        
        let winMessage = SKSpriteNode(imageNamed: "WinMessage")
        winMessage.size = self.size 
        winMessage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2) 
        winMessage.zPosition = 3 
        winMessage.alpha = 0 
        
        self.addChild(winMessage)
    
        let winSound = SKAction.playSoundFileNamed("WinSound", waitForCompletion: false)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.8)
        
        let sequence = SKAction.sequence([winSound, fadeIn])
        winMessage.run(sequence)
    }
    
    func addButtons() {
        
        let playAgainButton = SKSpriteNode(imageNamed: "PlayAgainButtonEndGame")
        playAgainButton.setScale(0.2)
        playAgainButton.position = CGPoint(x: self.size.width / 1.4, y: self.size.height * 0.1)
        playAgainButton.name = "PlayAgainButton"
        playAgainButton.zPosition = 10
        playAgainButton.alpha = 1.0
        
        self.addChild(playAgainButton)
        
        let mainMenuButton = SKSpriteNode(imageNamed: "MainMenuButtonEndGame")
        mainMenuButton.setScale(0.2)
        mainMenuButton.position = CGPoint(x: self.size.width / 3.4, y: self.size.height * 0.1)
        mainMenuButton.name = "MainMenuButton"
        mainMenuButton.zPosition = 10
        mainMenuButton.alpha = 1.0
        
        self.addChild(mainMenuButton)
        
        print("PlayAgainButton alpha:", playAgainButton.alpha)
        print("MainMenuButton alpha:", mainMenuButton.alpha)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            
            for node in touchedNodes {
                if node.name == "PlayAgainButton" {
                    stopBackgroundMusic() 
                    let gameScene = GameScene(size: self.size)
                    gameScene.scaleMode = self.scaleMode
                    self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 1.0))
                } else if node.name == "MainMenuButton" {
                    stopBackgroundMusic() 
                    let mainMenuScene = MainMenuScene(size: self.size)
                    mainMenuScene.scaleMode = self.scaleMode
                    self.view?.presentScene(mainMenuScene, transition: SKTransition.fade(withDuration: 1.0))
                }
            }
        }
    }
    
    func playBackgroundMusic() {
        let backgroundMusic = SKAudioNode(fileNamed: "HappyEnding")
        backgroundMusic.autoplayLooped = true 
        addChild(backgroundMusic)
    }
    
    func stopBackgroundMusic() {
        backgroundMusic?.removeFromParent()
        backgroundMusic = nil
    }
    
}
