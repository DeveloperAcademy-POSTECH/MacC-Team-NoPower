//
//  CalenderViewController.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit


class CalendarViewController: UIViewController {
    
    //MARK: -Properties
    
    static var monthAddedMemory: Int = 0
    let calendarDateFormatter = CalendarDateFormatter()
    
    private let CalendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 20
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let VisitInfInfoView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(hex: "F5F5F5")
        collectionView.register(VisitingInfoCell.self, forCellWithReuseIdentifier: VisitingInfoCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let VisitInfoHeader: UILabel = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        let day = formatter.string(from: Date())
        
        
        let label = UILabel()
        label.text = day
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.textColor = CustomColor.nomadBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calendarCollectionYearHeader: UILabel = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from:Date())
        
        
        let label = UILabel()
        label.text = year
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calendarCollectionMonthHeader: UILabel = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월"
        let month = formatter.string(from:Date())
        
        
        let label = UILabel()
        label.text = month
        label.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dayOfWeekStackView: UIStackView = {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        var stack = UIStackView()
        stack.distribution = .fillEqually
        dayOfTheWeek.forEach {
            let label = UILabel()
            label.text = $0
            label.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
            label.textColor = .black
            if $0 == "일" || $0 == "토" {
                label.textColor = CustomColor.nomadSkyblue
            }
            label.textAlignment = .center
            stack.addArrangedSubview(label)
        }
        return stack
    }()
    
    
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CalendarCollectionView.dataSource = self
        CalendarCollectionView.delegate = self
        
        VisitInfInfoView.dataSource = self
        VisitInfInfoView.delegate = self
        
        configureUI()
        render()
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Actions
    
    //MARK: -Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(hex: "F5F5F5")
    }
    
    func render() {
        
        view.addSubview(CalendarCollectionView)
        CalendarCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                      paddingTop: 105, paddingLeft: 14, paddingRight: 14,
                                      height: 388)
        
        view.addSubview(calendarCollectionYearHeader)
        calendarCollectionYearHeader.anchor(top: CalendarCollectionView.topAnchor)
        calendarCollectionYearHeader.centerX(inView: view)
        
        view.addSubview(calendarCollectionMonthHeader)
        calendarCollectionMonthHeader.anchor(top: calendarCollectionYearHeader.bottomAnchor)
        calendarCollectionMonthHeader.centerX(inView: view)
        
        view.addSubview(VisitInfInfoView)
        VisitInfInfoView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                paddingTop: 557, paddingLeft: 14, paddingRight: 14, height: 256)
        
        view.addSubview(VisitInfoHeader)
        VisitInfoHeader.anchor(top: CalendarCollectionView.bottomAnchor, paddingTop: 21)
        VisitInfoHeader.centerX(inView: view)
        
        view.addSubview(dayOfWeekStackView)
        dayOfWeekStackView.anchor(top: calendarCollectionMonthHeader.bottomAnchor, paddingTop: 15, width: 358-358/7)
        dayOfWeekStackView.centerX(inView: view)
        
    }
    
}

//MARK: -Extentions

extension CalendarViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CalendarCollectionView {
            return self.calendarDateFormatter.days.count
        } else {
            return 2 //TODO: 반응형 수정 필요
        }
    }
    
}

extension CalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CalendarCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier , for: indexPath) as? CalendarCell else {
                return UICollectionViewCell()
            }
            
            cell.configureLabel(text: self.calendarDateFormatter.days[indexPath.item])
            if indexPath.item%7 == 0 || indexPath.item%7 == 6 {
                cell.setWeekendColor()
            }
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitingInfoCell.identifier , for: indexPath) as? VisitingInfoCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            return cell
            
        }
    }
    
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == CalendarCollectionView {
            return CGSize(width: 358/8, height: 358/7)
        } else {
            return CGSize(width: 358, height: 119)
        }
        
    }
    
    //cell 횡간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return CGFloat(0)
    }
    
    //cell 종간 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == CalendarCollectionView {
            return UIEdgeInsets(top: 70, left: 358/14, bottom: 0, right: 358/14)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
}


class CalendarDateFormatter {
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var nowCalendarDate = Date()
    private(set) var days = [String]()
    
    init() {
        updateCurrentMonthDays()
    }
    
    func getStartingDayOfWeek() -> Int {
        let dayCorrector = self.calendar.component(.day, from: self.nowCalendarDate) % 7
        var startingDay = self.calendar.component(.weekday, from: self.nowCalendarDate) - dayCorrector
        if startingDay < 0 {
            startingDay += 7
        }
        return startingDay
    }
    
    func getEndDateOfMonth() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.nowCalendarDate)?.count ?? 0
    }
    
    func updateCurrentMonthDays() {
        self.days.removeAll()
        
        let startDayOfWeek = self.getStartingDayOfWeek()
        let totalDaysOfMonth = startDayOfWeek + self.getEndDateOfMonth()
        
        for day in 0..<totalDaysOfMonth {
            if day < startDayOfWeek {
                self.days.append("")
            } else {
                self.days.append("\(day - startDayOfWeek + 1)")
            }
        }
    }
    
}

