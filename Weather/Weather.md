# Weather Project


## 1. URLSession으로 Weather API data 불러오기

### URLSession Life Cycle

1. Session Configuration 을 결정하고, Session 을 생성
2. 통신할 URL과 Request 객체를 설정
3. 사용할 Task 를 결정하고 그에 맞는 Completion Handler 나 Delegate 메소드들을 작성
4. 해당Task를실행
5. Task 완료 후 Completion Handler 클로저가 호출이 됨

### * DispatchQueue.main.async : 작업을 수행할 다른 큐에게 작업을 넘기자마자 현재의 queue(main)에게 컨트롤을 돌려주는 메소드.


 ```swift
 
 func getCurrentWeather (cityName : String){
 //guard문으로 url 주소 선언 
  guard let url = URL(string: "api 주소") else {return}
  
  let session = URLSession(configuration : .default)
  //사용할 Task 결정, completion handler 클로저 작성
  session.dataTask(with: url){ [weak self] data, response, error in 
    let successRange = (200..<300) 
    guard let data = data, error == nil else { return }
    
    let decoder = JsonDecoder() //decoder 호출
    if let response = response as? HTTPURLResponse,
      successRange.contains(response.statusCode){
        //response의 statusCode가 successRange에 있는 경우 : 성공
        guard let weatherInformation = try?
          decoder.decode(WeatherInformation.self, from:data) else {return}
        
        DispatchQueue.main.async{
          //Weather정보가 있는 weatherStackView를 보이게 하고 정보 불러오기
          self?.weatherStackView.isHidden = false
          self?.configureView(weatherInformation: weatherInformation)
          }
      }else{
      //response의 statusCode 가 successRange에 없는 경우 : error
       guard let erroMessage = try? decoder.decode(ErrorMessage.self, from:data) else {return}
       DispatchQueue.main.async{
        self?.showAlert(message: errorMessage.message)
        }
       }
      }.resume()
    }
   }
  ```
  
## 2. Codable 프로토콜로 Weather Api 상세 data 가져오기

 ```swift
 
 struct WeatherInformation : Codable {
  let weather : [Weather]
  let temp : Temp
  let name : String
  
  enum CodingKeys : String, CodingKey{
    //json 파일의 key값을 원하는 key이름으로 CodingKeys 프로토콜로 변환하기
    case weather
    case temp = "main"
    case name
   }
 }
 
 struct Temp : Codable { //도시별 기온 상세정보 Temp 구조체
  let temp : Double
  let feelsLike : Double
  let minTemp : Double
  let maxTemp : Double 
  
  enum CodingKeys : String, CodingKey{
    case temp
    case feelsLike = "feels_like"
    case minTemp = "temp_min"
    case maxTemp = "temp_max"
   }
 }
 ```
 
 ## 3. UIAlertController로 에러 alert 표현하기
 
 ```swift
 
 func showAlert(message : String){
  let alert = UIAlertController(title:"에러", style:.default, handler: nil))
  self.present(alert, animated:true, completion: nil)
  }
 ```
 
 
