//
//  GameViewController.swift
//  SwGame
//
//  Created by Тимур Кошевой on 1/4/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import RealmSwift

class GameViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var _pauseButton: UIButton!
    @IBOutlet weak var _pauseView: UIView!
    @IBOutlet weak var _timerLabel: UILabel!
    @IBOutlet weak var _continueButton: UIButton!
    @IBOutlet weak var _playAgainButton: UIButton!
    @IBOutlet weak var _mainMenuButton: UIButton!
    @IBOutlet weak var _lastScoreLabel: UILabel!
    
    let realm = try! Realm()
    var player: AVAudioPlayer!
    var seconds = 30
    var savedSeconds = 0
    var timer = Timer()
    var isTimerRunning = false
    
    private var userScore: Int = 0 {
        didSet {
            // ensure UI update runs on main thread
            DispatchQueue.main.async {
                self.scoreLabel.text = "Score: \(String(self.userScore))"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _pauseView.isHidden = true
        
        sceneView.delegate = self
        
        // Приховати статистику про FPS
        sceneView.showsStatistics = false
        
        setUpOutlets()
        
        // Створити нову сцену
        let scene = SCNScene()
        
        // Встановити сцену на View
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
        
        self.addNewEnemy()
        
        self.userScore = 0
        
        runTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Пауза сесії при прихованні ViewController
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - ARSCNViewDelegate
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Session failed with error: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func runTimer() {
        // ініціалізація таймеру
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    func SaveUserScore() {
        
        let def = UserDefaults.standard
        let currentUser = def.string(forKey: "currentUser")
        
        let currentUserResult = realm.objects(TopScores.self).filter("userName = %@", currentUser!)
        let currentUserPreviosScore = currentUserResult[0].score
        let userPreviousScoreInt = Int(currentUserPreviosScore!)
        
        if let currentUserResult = currentUserResult.first {
            
            if (userScore > userPreviousScoreInt!) {
                try! realm.write {
                    currentUserResult.score = String(userScore)
                }
            } else {
                return
            }
        }
        
    }
    
    @objc func updateTimer() {
        // якщо час закінчився
        if seconds == 0 {
            
            // зупиняємо таймер
            timer.invalidate()
            // відображаемо екран паузи
            self._pauseView.isHidden = false
            // зупиняємо сцену
            self.sceneView.scene.isPaused = true
            // та ховаємо кнопку "Продовжити гру" так як ця функція не доступна після завершення гри
            self._continueButton.isHidden = true
            self._lastScoreLabel.text = "Last score: \(userScore)"
            SaveUserScore()
        }else{
            
            if seconds < 11 {
                
                scoreLabel.textColor = UIColor.red
                _timerLabel.textColor = UIColor.red
                // якщо чай не закінчився то кожну секунду віднімаємо одну одиницю
                self._continueButton.isHidden = false
                seconds -= 1
                // та відображаємо на єкрані
                self._timerLabel.text = "\(seconds)s"
            } else {
                // якщо чай не закінчився то кожну секунду віднімаємо одну одиницю
                self._continueButton.isHidden = false
                seconds -= 1
                // та відображаємо на єкрані
                self._timerLabel.text = "\(seconds)s"
            }
            
        }
        
    }
    
    // обнулення таймеру
    func resetTimer(){
        timer.invalidate()
        seconds = 30
        self._timerLabel.text = "\(seconds)s"
    }
    
    func setUpOutlets() {
        _continueButton.layer.cornerRadius = 5
        _pauseButton.layer.cornerRadius = 5
        _mainMenuButton.layer.cornerRadius = 5
        _playAgainButton.layer.cornerRadius = 5
    }
    
    // MARK: - Actions
    
    // стріляємо кулею в няпрямок куди дивиться камера
    @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) {
        
        self.playSoundEffect(ofType: .bullet)
        
        let bulletsNode = Bullet()
        
        let (direction, position) = self.getUserVector()
        bulletsNode.position = position
        
        let bulletDirection = direction
        bulletsNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
        
//        let velocityInLocalSpace = SCNVector3(-0.15, -0.15, -0.15)
//        let velocityInWorldSpace = bulletsNode.presentation.convertVector(velocityInLocalSpace, to: nil)
//        bulletsNode.physicsBody?.velocity = velocityInWorldSpace
        
        print(bulletsNode.physicsBody?.velocity)
        
        sceneView.scene.rootNode.addChildNode(bulletsNode)
        
    }
    
    func configureSession() {
        if ARWorldTrackingConfiguration.isSupported { // перевірка, чи девайс підтримує ARWorldTrackingSessionConfiguration
            
            // створення кофігурації сесії
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = ARWorldTrackingConfiguration.PlaneDetection.horizontal
            
            // запуск сесії
            sceneView.session.run(configuration)
        } else {
            // якщо девайс не підтримує ARWorldTrackingSessionConfiguration то використовуємо AROrientationTrackingConfiguration
            let configuration = AROrientationTrackingConfiguration()
            
            // запуск сесії
            sceneView.session.run(configuration)
        }
    }
    
    func addNewEnemy() {
        
        let enemyNode = Enemy()
        
        let posX = Float.random(min: -0.9, max: 0.9)
        let posY = Float.random(min: -0.9, max: 0.9)
        let posZ = Float.random(min: -0.5, max: -1.5)
        enemyNode.position = SCNVector3(posX, posY, posZ)
        addAnimation(node: enemyNode)
        sceneView.scene.rootNode.addChildNode(enemyNode)
        
    }
    
    func addAnimation(node: SCNNode) {
        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5.0)
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.1, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.1, z: 0, duration: 2.5)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let rotateAndHover = SCNAction.group([rotateOne, hoverSequence])
        let repeatForever = SCNAction.repeatForever(rotateAndHover)
        node.runAction(repeatForever)
    }
    
    func removeNodeWithAnimation(_ node: SCNNode, explosion: Bool) {
        
        self.playSoundEffect(ofType: .collision)
        
        if explosion {
            
            // Play explosion sound for bullet-ship collisions
            
            self.playSoundEffect(ofType: .explosion)
            
            let particleSystem = SCNParticleSystem(named: "explosion", inDirectory: nil)
            let systemNode = SCNNode()
            systemNode.addParticleSystem(particleSystem!)
            // place explosion where node is
            systemNode.position = node.position
            sceneView.scene.rootNode.addChildNode(systemNode)
        }
        
        // remove node
        node.removeFromParentNode()
    }
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-2 * mat.m31, -2 * mat.m32, -2 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    // MARK: - Contact Delegate
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue {
            
            self.removeNodeWithAnimation(contact.nodeB, explosion: false) // видаляємо кулю з View
            self.userScore += 1
            
            // видаляємо об'єкт ворога після зіткнення з кулею та створюємо нові об'єкти ворогів
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                
                self.removeNodeWithAnimation(contact.nodeA, explosion: true)
                self.addNewEnemy()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.addNewEnemy()
            })
            
        }
    }
    
    // MARK: - Sound Effects
    
    func playSoundEffect(ofType effect: SoundEffect) {
        
        DispatchQueue.main.async {
            do
            {
                if let effectURL = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") {
                    
                    self.player = try AVAudioPlayer(contentsOf: effectURL)
                    self.player.play()
                    
                }
            }
            catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        timer.invalidate()
        _pauseView.isHidden = false
        sceneView.scene.isPaused = true
        _pauseButton.isHidden = true
        _lastScoreLabel.isHidden = false
        _lastScoreLabel.text = "Last score: \(userScore)"
    }
    
    @IBAction func continueButton(_ sender: Any) {
        sceneView.scene.isPaused = false
        _pauseView.isHidden = true
        _pauseButton.isHidden = false
        runTimer()
    }
    
    @IBAction func playAgainButton(_ sender: Any) {
        
        let scene = SCNScene()
        scoreLabel.textColor = UIColor.white
        _timerLabel.textColor = UIColor.white
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
        
        self.addNewEnemy()
        
        self.userScore = 0
        resetTimer()
        runTimer()
        _pauseView.isHidden = true
        _pauseButton.isHidden = false
        _continueButton.isHidden = false
    }
    
    @IBAction func mainMenuButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let bullets  = CollisionCategory(rawValue: 1 << 0)
    static let enemy = CollisionCategory(rawValue: 1 << 1)
    
}

extension utsname {
    func hasAtLeastA9() -> Bool { // checks if device has at least A9 chip for configuration
        var systemInfo = self
        uname(&systemInfo)
        let str = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        switch str {
        case "iPhone8,1", "iPhone8,2", "iPhone8,4", "iPhone9,1", "iPhone9,2", "iPhone9,3", "iPhone9,4": // iphone with at least A9 processor
            return true
        case "iPad6,7", "iPad6,8", "iPad6,3", "iPad6,4", "iPad6,11", "iPad6,12": // ipad with at least A9 processor
            return true
        default:
            return false
        }
    }
}

enum SoundEffect: String {
    case explosion = "explosion"
    case collision = "collision"
    case bullet = "torpedo"
}

public extension Float {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
