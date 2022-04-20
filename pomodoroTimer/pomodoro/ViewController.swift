//
//  ViewController.swift
//  pomodoro
//
//  Created by Chrissy Lee on 2022/04/20.
//

import UIKit
import AudioToolbox

enum TimerStatus{
    case start
    case pause
    case end
}

class ViewController: UIViewController{

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    @IBOutlet weak var ImageView: UIImageView!
    var duration = 60
    var timerStatus : TimerStatus = .end //타이머 상태 저장 변수
    var timer : DispatchSourceTimer?
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }

    func setTimerInfoViewVisible(isHidden : Bool){
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton(){
        //시작버튼 초기상태에 다른 타이틀 구현
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
        
    }
    
    //타이머 시작 메서드
    func startTimer(){
        if self.timer == nil{
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: {[weak self] in
                guard let self = self else {return} //self를 일시적으로 strong 참조
                self.currentSeconds -= 1
                // timerlabel에 currentTime 표시하기
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                //progressView 현황 나타내기
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                UIView.animate(withDuration: 0.5, delay: 0 , animations: {
                    self.ImageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                UIView.animate(withDuration: 0.5, delay : 0.5, animations: {
                    self.ImageView.transform = CGAffineTransform(rotationAngle: .pi*2)
                })
                
                if self.currentSeconds <= 0 {
                    //타이머 종료
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005) //타이머 종료 시 알람 
                }
            })
            self.timer?.resume()
        }
    }
    //타이머 정지 메서드
    func stopTimer(){
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        
        self.timerStatus = .end
        self.cancelButton.isEnabled = false //cancel 버튼 비활성화
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.ImageView.transform = .identity
        })
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil //메모리에서 할당 해제
    }
    //취소버튼 탭 메서드
    @IBAction func tapCancelButton(_ sender: UIButton) {
        
        switch self.timerStatus {
            
        case .start, .pause : //취소버튼을 눌렀을 때
            self.stopTimer()
            
        default:
            break
        }
    }
    //시작버튼 탭 메서드
    @IBAction func tapToggleButton(_ sender: UIButton) {
        //datePicker에서 설정한 시간 duration에 저장
        self.duration = Int(self.datePicker.countDownDuration)
        
        switch self.timerStatus{
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            //start에서는 다시 타이머 설정 메뉴가 보이게 함
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
    
        }

    }
}

