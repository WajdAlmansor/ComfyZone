import SpriteKit

class GameOverScene: SKScene {
    
    var gameTimerAtLoss: TimeInterval = 0 
    private var lostSound: SKAudioNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black 
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5) 
        
        playLostSound()
        addGameOverMessage() 
        addButtons() 
    }
    
    func playLostSound() {
        
        if let soundURL = Bundle.main.url(forResource: "LostSound", withExtension: "wav") { 
            lostSound = SKAudioNode(url: soundURL)
            lostSound.autoplayLooped = true 
            lostSound.isPositional = false  
            addChild(lostSound)
            
            lostSound.run(SKAction.play())
        }
    }
    
    
    func addGameOverMessage() {
        let gameOverImage: SKSpriteNode
        
        
        if gameTimerAtLoss > 30 {
            gameOverImage = SKSpriteNode(imageNamed: "Lost1Message") 
        } else {
            gameOverImage = SKSpriteNode(imageNamed: "Lost2Message") 
        }
        
        gameOverImage.setScale(0.8) 
        gameOverImage.position = CGPoint(x: 0, y: 0) 
        gameOverImage.zPosition = 1 

        self.addChild(gameOverImage)
    }
    
    func addButtons() {
        let tryAgainButton = SKSpriteNode(imageNamed: "TryAgainButton")
        tryAgainButton.setScale(0.1) 
        tryAgainButton.position = CGPoint(x: 400, y: -405) 
        tryAgainButton.name = "TryAgainButton"
        tryAgainButton.zPosition = 2 
        
        self.addChild(tryAgainButton)
        
        let mainMenuButton = SKSpriteNode(imageNamed: "MainMenuButton")
        mainMenuButton.setScale(0.1) 
        mainMenuButton.position = CGPoint(x: -400, y: -400) 
        mainMenuButton.name = "MainMenuButton"
        mainMenuButton.zPosition = 2 
        
        self.addChild(mainMenuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            for node in touchedNodes {
                if node.name == "TryAgainButton" {
                    let newGameScene = GameScene(size: self.size)
                    newGameScene.scaleMode = self.scaleMode
                    self.view?.presentScene(newGameScene, transition: SKTransition.fade(withDuration: 1.0))
                } else if node.name == "MainMenuButton" {
                    let mainMenuScene = MainMenuScene(size: self.size) 
                    mainMenuScene.scaleMode = self.scaleMode
                    self.view?.presentScene(mainMenuScene, transition: SKTransition.fade(withDuration: 1.0))
                }
            }
        }
    }
    
    func stopLostSound() {
        lostSound?.removeFromParent() 
    }
}
