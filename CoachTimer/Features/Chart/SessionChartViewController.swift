//
//  SessionChartViewController.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 21/06/21.
//

import UIKit
import SwiftCharts
import RxComposableArchitecture
import RxSwift
import RxCocoa
import SceneBuilder

class SessionChartViewController: UIViewController {

	public var store: Store<SessionState, SessionAction>?
	
	private let disposeBag = DisposeBag()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		store?.value
			.map { (state: SessionState) -> [Lap] in
				state.laps
			}
			.map { laps -> TrendlineExample in
				let controller = TrendlineExample()
				
				controller.laps = laps
				
				return controller
			}
			.bind(to: self.rx.addChild)
			.disposed(by: disposeBag)
    }
}

extension Reactive where Base: SessionChartViewController {
	var addChild: Binder<(UIViewController)> {
		Binder(base) { base, controller in
			base.addChild(controller)
			base.view.addSubview(controller.view)
		}
	}
}


class TrendlineExample: UIViewController {
	fileprivate var chart: Chart? // arc
	
	public var laps: [Lap] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print(laps)
		
		let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
				
		let chartPoints: [ChartPoint] =
			laps
			.map { ($0.id, $0.time) }
			.map {
				ChartPoint(
					x: ChartAxisValueDouble($0.0, labelSettings: labelSettings),
					y: ChartAxisValueDouble($0.1)
				)
			}

		let xValues = chartPoints.map{$0.x}
		let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
		
		let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, animDuration: 1, animDelay: 0)

		let trendLineModel = ChartLineModel(chartPoints: TrendlineGenerator.trendline(chartPoints), lineColor: UIColor.blue, animDuration: 0.5, animDelay: 1)
		
		let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
		let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "speed (100 [ms])", settings: labelSettings.defaultVertical()))
		let chartFrame = ExamplesDefaults.chartFrame(view.bounds)
		
		let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom

		let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
		let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
		
		let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel])

		let trendLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [trendLineModel])

		let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
		let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
		
		let chart = Chart(
			frame: chartFrame,
			innerFrame: innerFrame,
			settings: chartSettings,
			layers: [
				xAxisLayer,
				yAxisLayer,
				guidelinesLayer,
				chartPointsLineLayer,
				trendLineLayer
			]
		)
		
		view.addSubview(chart.view)
		
		self.chart = chart
	}
}

struct ExamplesDefaults {
	
	static var chartSettings: ChartSettings {
		if Env.iPad {
			return iPadChartSettings
		} else {
			return iPhoneChartSettings
		}
	}

	static var chartSettingsWithPanZoom: ChartSettings {
		if Env.iPad {
			return iPadChartSettingsWithPanZoom
		} else {
			return iPhoneChartSettingsWithPanZoom
		}
	}
	
	fileprivate static var iPadChartSettings: ChartSettings {
		var chartSettings = ChartSettings()
		chartSettings.leading = 20
		chartSettings.top = 20
		chartSettings.trailing = 20
		chartSettings.bottom = 20
		chartSettings.labelsToAxisSpacingX = 10
		chartSettings.labelsToAxisSpacingY = 10
		chartSettings.axisTitleLabelsToLabelsSpacing = 5
		chartSettings.axisStrokeWidth = 1
		chartSettings.spacingBetweenAxesX = 15
		chartSettings.spacingBetweenAxesY = 15
		chartSettings.labelsSpacing = 0
		return chartSettings
	}
	
	fileprivate static var iPhoneChartSettings: ChartSettings {
		var chartSettings = ChartSettings()
		chartSettings.leading = 10
		chartSettings.top = 10
		chartSettings.trailing = 10
		chartSettings.bottom = 10
		chartSettings.labelsToAxisSpacingX = 5
		chartSettings.labelsToAxisSpacingY = 5
		chartSettings.axisTitleLabelsToLabelsSpacing = 4
		chartSettings.axisStrokeWidth = 0.2
		chartSettings.spacingBetweenAxesX = 8
		chartSettings.spacingBetweenAxesY = 8
		chartSettings.labelsSpacing = 0
		return chartSettings
	}

	fileprivate static var iPadChartSettingsWithPanZoom: ChartSettings {
		var chartSettings = iPadChartSettings
		chartSettings.zoomPan.panEnabled = true
		chartSettings.zoomPan.zoomEnabled = true
		return chartSettings
	}

	fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
		var chartSettings = iPhoneChartSettings
		chartSettings.zoomPan.panEnabled = true
		chartSettings.zoomPan.zoomEnabled = true
		return chartSettings
	}
	
	static func chartFrame(_ containerBounds: CGRect) -> CGRect {
		return CGRect(x: 0, y: 70, width: containerBounds.size.width, height: containerBounds.size.height - 70)
	}
	
	static var labelSettings: ChartLabelSettings {
		return ChartLabelSettings(font: ExamplesDefaults.labelFont)
	}
	
	static var labelFont: UIFont {
		return ExamplesDefaults.fontWithSize(Env.iPad ? 14 : 11)
	}
	
	static var labelFontSmall: UIFont {
		return ExamplesDefaults.fontWithSize(Env.iPad ? 12 : 10)
	}
	
	static func fontWithSize(_ size: CGFloat) -> UIFont {
		return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
	}
	
	static var guidelinesWidth: CGFloat {
		return Env.iPad ? 0.5 : 0.1
	}
	
	static var minBarSpacing: CGFloat {
		return Env.iPad ? 10 : 5
	}
}

class Env {
	static var iPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}
}
