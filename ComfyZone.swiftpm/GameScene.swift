
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var Girl: SKSpriteNode! 
    private var spawnTimer: TimeInterval = 0 
    private var gameTimer: TimeInterval = 60 
    private var isGameOver = false 
    private var timerLabel: SKLabelNode! 
    private var hasChangedBackground = false 
    private var backgroundSound: SKAudioNode!
    private var hasChangedMusic = false 
    private var newBackgroundSound: SKAudioNode!
    private var isPlayingTickSound = false
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.contactDelegate = self 
        
        
        if let soundURL = Bundle.main.url(forResource: "backgroundSound", withExtension: "mp3") {
            backgroundSound = SKAudioNode(url: soundURL)
            backgroundSound.autoplayLooped = true 
            backgroundSound.isPositional = true 
            addChild(backgroundSound)
        }
        
        
        createBackgrounds()
        addGirl()
        addTimerLabel() 
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackgrounds()
        
        if !isGameOver {
            let previousTime = Int(gameTimer) 
            gameTimer -= 1.0 / 60.0
            let currentTimeInt = Int(gameTimer) 
            
            if gameTimer <= 0 {
                gameTimer = 0
                isGameOver = true 
                removeAllHands() 
                goToWinScene()
                return
            }
            
            if gameTimer <= 30 && !hasChangedBackground {
                changeBackgroundToNew()
                hasChangedBackground = true
            }
            
            let spawnInterval: TimeInterval = gameTimer <= 30 ? 2.5 : 2.0
            let handSpeed: TimeInterval = gameTimer <= 30 ? 3.5 : 3.0
            let numberOfHands = gameTimer <= 30 ? 2 : 1
            
            if gameTimer > 0, currentTime - spawnTimer > spawnInterval {
                for _ in 0..<numberOfHands {
                    spawnHands(speed: handSpeed)
                }
                spawnTimer = currentTime
            }
            
            updateTimerLabel()
            
            if currentTimeInt <= 5 && currentTimeInt > 0 && previousTime != currentTimeInt {
                let tickSound = SKAction.playSoundFileNamed("TikClock", waitForCompletion: false)
                self.run(tickSound)
            }
        }
        
        if gameTimer <= 30 && !hasChangedMusic {
            changeBackgroundMusic()
            hasChangedMusic = true
        }
    }
    
    
    
    func createBackgrounds() {
        for i in 0...3 {
            let background = SKSpriteNode(imageNamed: "Background1")
            background.name = "Background"
            
        
            background.size = CGSize(width: 2150, height: 1179)
            
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.position = CGPoint(x: 0, y: CGFloat(i) * background.size.height)
            
            self.addChild(background)
        }
        
    }
    
    
    func moveBackgrounds() {
        self.enumerateChildNodes(withName: "Background", using: { node, _ in
            if self.hasChangedBackground {
            
                node.position.y -= 10
            } else {
            
                node.position.y -= 2
            }
            
            if node.position.y < -self.size.height {
                node.position.y += self.size.height * 3
            }
        })
    }
    
    
    func addGirl() {
        Girl = SKSpriteNode(imageNamed: "Girl")
        Girl.setScale(1)
        Girl.position = CGPoint(x: 0, y: 0)
        Girl.zPosition = 2
        Girl.name = "Girl"
        
        Girl.physicsBody = SKPhysicsBody(circleOfRadius: Girl.size.width * 0.15)
        Girl.physicsBody?.categoryBitMask = 1
        Girl.physicsBody?.collisionBitMask = 0
        Girl.physicsBody?.contactTestBitMask = 2
        Girl.physicsBody?.affectedByGravity = false
        Girl.physicsBody?.isDynamic = true
        
        self.addChild(Girl)
    }
    
    func spawnHands(speed: TimeInterval) {
        let texture1 = SKTexture(imageNamed: "Hand1")
        let texture2 = SKTexture(imageNamed: "Hand2")
        let texture3 = SKTexture(imageNamed: "Hand3")
        
        let frames = [texture1, texture2, texture3]
        
        let startX = CGFloat.random(in: -self.size.width...self.size.width)
        let startY = -self.size.height - 50
        
        let handFly = SKSpriteNode(texture: texture1)
        handFly.setScale(0.5)
        handFly.position = CGPoint(x: startX, y: startY)
        handFly.zPosition = 2
        handFly.name = "monster"
        
        handFly.physicsBody = SKPhysicsBody(circleOfRadius: handFly.size.width * 0.15)
        handFly.physicsBody?.categoryBitMask = 2
        handFly.physicsBody?.collisionBitMask = 0
        handFly.physicsBody?.contactTestBitMask = 1
        handFly.physicsBody?.affectedByGravity = false
        handFly.physicsBody?.isDynamic = true
        
        self.addChild(handFly)
        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.2)
        let repeatAnimation = SKAction.repeatForever(animation)
        handFly.run(repeatAnimation)
        
    
        let moveToGirl = SKAction.move(to: Girl.position, duration: speed)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveToGirl, remove])
        
        handFly.run(sequence)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        
        if (bodyA?.name == "Girl" && bodyB?.name == "monster") ||
            (bodyA?.name == "monster" && bodyB?.name == "Girl") {
            
            let hitSound = SKAction.playSoundFileNamed("HitSound", waitForCompletion: false)
            self.run(hitSound)
            
            self.enumerateChildNodes(withName: "monster") { node, _ in
                node.removeAllActions()
                node.physicsBody = nil 
            }
            
            
            let wait = SKAction.wait(forDuration: 0.3)
            let gameOverAction = SKAction.run { self.goToGameOver() }
            let sequence = SKAction.sequence([wait, gameOverAction])
            
            self.run(sequence)
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            for node in touchedNodes {
                if node.name == "monster" {
                    fadeOutAndDisappear(node: node)
                }
            }
        }
    }
    
    func fadeOutAndDisappear(node: SKNode) {
        node.physicsBody = nil
        
        let soundEffect = SKAction.playSoundFileNamed("HandSound", waitForCompletion: false)
        
        let fadeToBlack = SKAction.colorize(with: .black, colorBlendFactor: 1.0, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([soundEffect, fadeToBlack, fadeOut, remove])
        
        node.run(sequence)
    }
    
    func goToGameOver() {
        isGameOver = true
        self.removeAction(forKey: "TickClockSound") 
        
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = self.scaleMode
        gameOverScene.gameTimerAtLoss = gameTimer 
        self.view?.presentScene(gameOverScene, transition: SKTransition.fade(withDuration: 1.0))
        
        backgroundSound.removeFromParent()
        newBackgroundSound?.removeFromParent()
    }
    
    
    func goToWinScene() {
        isGameOver = true
        self.removeAction(forKey: "TickClockSound") 
        
        let winScene = WinScene(size: self.size)
        winScene.scaleMode = self.scaleMode
        self.view?.presentScene(winScene, transition: SKTransition.fade(withDuration: 1.0)) 
        
        backgroundSound.removeFromParent()
        newBackgroundSound?.removeFromParent()
    }
    
    func addTimerLabel() {
        let timeTitleImage = SKSpriteNode(imageNamed: "TimeTitle")
        timeTitleImage.setScale(0.3) 
        timeTitleImage.zPosition = 3 
        
        
        timeTitleImage.position = CGPoint(x: self.size.width / 2 - 2050, y: self.size.height / 2 - 55)
        
        self.addChild(timeTitleImage)
        
        
        timerLabel = SKLabelNode(text: "\(Int(gameTimer))")
        timerLabel.fontName = "Chalkduster"
        timerLabel.fontSize = 60
        timerLabel.fontColor = .white
        timerLabel.horizontalAlignmentMode = .left 
        timerLabel.verticalAlignmentMode = .top 
        
        
        timerLabel.position = CGPoint(x: timeTitleImage.position.x + timeTitleImage.size.width / 2 + -15,
                                      y: timeTitleImage.position.y)
        timerLabel.zPosition = 3
        
        self.addChild(timerLabel)
    }
    
    
    func updateTimerLabel() {
        timerLabel.text = "\(Int(gameTimer))" 
    }
    
    func changeBackgroundToNew() {
        self.enumerateChildNodes(withName: "Background") { node, _ in
            if let background = node as? SKSpriteNode {
                background.texture = SKTexture(imageNamed: "Background2")
                
                background.size = CGSize(width: 2150, height: 1179)
            }
        }
        
        hasChangedBackground = true
    }
    
    
    func removeAllHands() {
        self.enumerateChildNodes(withName: "monster") { node, _ in
            node.removeAllActions() 
            node.removeFromParent() 
        }
    }
    
    func changeBackgroundMusic() {
        backgroundSound.removeFromParent()
        
        if let soundURL = Bundle.main.url(forResource: "backgroundSound2", withExtension: "mp3") {
            newBackgroundSound = SKAudioNode(url: soundURL)
            newBackgroundSound.autoplayLooped = true
            addChild(newBackgroundSound) 
        }
    }

}
