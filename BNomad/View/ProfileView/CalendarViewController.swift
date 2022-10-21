//
//  CalenderViewController.swift
//  BNomad
//
//  Created by Beone on 2022/10/19.
//

import UIKit


class CalendarViewController: UIViewController {
    
    //MARK: -Properties
    
    var monthAddedMemory: Int = 0
    private var selectedCell: Int? = 100
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
        let day = String(Contents.getTodayDate()[1])+"월 "+String(Contents.getTodayDate()[2])+"일"
        
        
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
    
    private let plusMonthButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let minusMonthButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CalendarCollectionView.dataSource = self
        CalendarCollectionView.delegate = self
        
        VisitInfInfoView.dataSource = self
        VisitInfInfoView.delegate = self
        
        plusMonthButton.addTarget(self, action: #selector(plusMonthTapButton), for: .touchUpInside)
        minusMonthButton.addTarget(self, action: #selector(minusMonthTapButton), for: .touchUpInside)
        
        configureUI()
        render()
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Actions
    
    @objc func plusMonthTapButton() {
        monthAddedMemory += 1
        calendarCollectionMonthHeader.text = String(Contents.getTodayDate()[1]+monthAddedMemory)+"월"
        
        selectedCell = nil
        
        calendarDateFormatter.updateCurrentMonthDays(addedMonth: monthAddedMemory)
        CalendarCollectionView.reloadData()
        
    }
    
    @objc func minusMonthTapButton() {
        monthAddedMemory -= 1
        calendarCollectionMonthHeader.text = String(Contents.getTodayDate()[1]+monthAddedMemory)+"월"
        
        selectedCell = nil

        calendarDateFormatter.updateCurrentMonthDays(addedMonth: monthAddedMemory)
        CalendarCollectionView.reloadData()
        
    }
    
    //MARK: -Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(hex: "F5F5F5")
    }
    
    func render() {
        
        view.addSubview(CalendarCollectionView)
        CalendarCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                      paddingTop: 105, paddingLeft: 14, paddingRight: 14,
                                      height: 388)
        
//        view.addSubview(calendarCollectionYearHeader)
//        calendarCollectionYearHeader.anchor(top: CalendarCollectionView.topAnchor)
//        calendarCollectionYearHeader.centerX(inView: view)
        
        view.addSubview(calendarCollectionMonthHeader)
        calendarCollectionMonthHeader.anchor(top: CalendarCollectionView.topAnchor, paddingTop: 10)
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
        
        view.addSubview(minusMonthButton)
        minusMonthButton.anchor(top: CalendarCollectionView.topAnchor, left: dayOfWeekStackView.leftAnchor, paddingTop: 15)
        view.addSubview(plusMonthButton)
        plusMonthButton.anchor(top: CalendarCollectionView.topAnchor, right: dayOfWeekStackView.rightAnchor, paddingTop: 15)
        
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
    
    //draw cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CalendarCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier , for: indexPath) as? CalendarCell else {
                return UICollectionViewCell()
            }
            cell.configureLabel(text: self.calendarDateFormatter.days[indexPath.item])
            
            if indexPath.item%7 == 0 || indexPath.item%7 == 6 {
                cell.setWeekendColor()
            }
            
            if indexPath.item == selectedCell {
                cell.setSelectedCell()
            } else {
                cell.setNormalCell()
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
    
//    cell click action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item >= calendarDateFormatter.getStartingDayOfWeek(addedMonth: monthAddedMemory) {
            selectedCell = indexPath.item
            CalendarCollectionView.reloadData()


            VisitInfoHeader.text = String(Contents.getTodayDate()[1]+monthAddedMemory)+"월 "+String(indexPath.item - calendarDateFormatter.getStartingDayOfWeek(addedMonth: monthAddedMemory)+1)+"일"
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
            return UIEdgeInsets(top: 75, left: 358/14, bottom: 0, right: 358/14)
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
        updateCurrentMonthDays(addedMonth: 0)
    }

    func getStartingDayOfWeek(addedMonth: Int) -> Int {
        let month = self.calendar.date(byAdding: .month, value: addedMonth, to: self.nowCalendarDate)

        guard let month = month else { return 0 }
        let dayCorrector = self.calendar.component(.day, from: month) % 7
        var startingDay = self.calendar.component(.weekday, from: month) - dayCorrector
        if startingDay < 0 {
            startingDay += 7
        }
        return startingDay
    }

    func getEndDateOfMonth(addedMonth: Int) -> Int {
        let month = self.calendar.date(byAdding: .month, value: addedMonth, to: self.nowCalendarDate)
        guard let month = month else { return 0 }

        return self.calendar.range(of: .day, in: .month, for: month)?.count ?? 0
    }

    func updateCurrentMonthDays(addedMonth: Int) {
        self.days.removeAll()

        let startDayOfWeek = self.getStartingDayOfWeek(addedMonth: addedMonth)
        let totalDaysOfMonth = startDayOfWeek + self.getEndDateOfMonth(addedMonth: addedMonth)

        for day in 0..<totalDaysOfMonth {
            if day < startDayOfWeek {
                self.days.append("")
            } else {
                self.days.append("\(day - startDayOfWeek + 1)")
            }
        }
    }

}
