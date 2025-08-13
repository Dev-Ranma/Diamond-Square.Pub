extends Node2D

var cellCoordsX : Array = [1]
var cellCoordsY : Array = [1]
var cellGridIndex : Array[Array] # 0: X-Coordinate, 1: Y-Coordinate, 2: Cell Fill, 3: Custom Variable
const GridSize : float = 1000.0
var cellNum : int = 3 #200 is hard limit for number of grid lines
var cellMax : int = cellNum * cellNum
var areLinesActive : bool = false
@onready var numSelect = $ItemList/NumSelect
var colorArray : Array[Color] = [Color.DARK_BLUE, Color.ROYAL_BLUE, Color.DEEP_SKY_BLUE, Color.PAPAYA_WHIP, Color.SEA_GREEN, Color.FOREST_GREEN, Color.DARK_GREEN, Color.GOLDENROD, Color.BROWN, Color.WEB_MAROON]
#@onready var clock = $Timer
#var holdUp : bool = false


func _ready() -> void:
	numSelect.text = str(cellNum)
	var popup = numSelect.get_popup()
	popup.id_pressed.connect(_on_num_select_pressed)
	_grid_points()
	_cell_fill_in()
	_draw()
	#diamond_square()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	$FPSLabel.text = "%d" % Engine.get_frames_per_second()

func _draw() -> void:
	var cellSize : float = GridSize / cellNum
	var cellResiduel : float = cellSize
	var i : int = 0
	var colorNum: int
	
	draw_rect(Rect2(0.0, 0.0, GridSize, GridSize), Color.WHITE, true, -1)
	
	while i < (cellNum * cellNum):
		if cellGridIndex[i][2] == 1:
			colorNum = cellGridIndex[i][3]
			draw_rect(Rect2((((cellGridIndex[i][0] - 1.0) / float(cellNum)) * GridSize ), (((cellGridIndex[i][1] - 1.0)/ float(cellNum)) * GridSize ), cellSize, cellSize), colorArray[colorNum], true)
		i += 1
	
	draw_rect(Rect2(0.0, 0.0, GridSize, GridSize), Color.RED, false, -4)
	
	if areLinesActive == true:
		for cells in (cellNum - 1):
			var lineStartX = Vector2(cellSize, 0.0)
			var lineEndX = Vector2(cellSize, GridSize)
			var lineStartY = Vector2(0.0, cellSize)
			var lineEndY = Vector2(GridSize, cellSize)
			draw_line(lineStartX, lineEndX, Color.RED)
			draw_line(lineStartY, lineEndY, Color.RED)
			cellSize += cellResiduel

func _grid_points():
	var x : int = 0
	var y : int = 0
	
	for cell in (cellNum * cellNum):
		cellGridIndex.resize(cellNum * cellNum)
		cellGridIndex[cell] = [(x+1), (y+1), 0, 0]
		x += 1
		if x == cellNum:
			x = 0
			y += 1

func _cell_fill_in():
	var i : int = 0
	var currentRand : int
	@warning_ignore("narrowing_conversion")
	var numOfFills : int = (cellNum * cellNum) * .75
	
	while i < numOfFills:
		i += 1
		currentRand = randi_range(0, ((cellNum * cellNum) - 1))
		cellGridIndex[currentRand][2] = 1

func diamond_square():
	var numCurrent = cellNum
	var maxCurrent = cellMax
	var cornerArray : Array = [0, (numCurrent - 1), ((maxCurrent - numCurrent)), (maxCurrent - 1)]
	var cornerIndexArray : Array
	var diamondCenter = ((maxCurrent - 1)/2) 
	var pointInbetweenX = ((numCurrent - 1) / 2)
	var pointInbetweenY = ((cellNum) * ((numCurrent - 1)/ 2) )
	var diamondSquareArray : Array = [diamondCenter, (diamondCenter - pointInbetweenX), (diamondCenter + pointInbetweenX), (diamondCenter - pointInbetweenY), (diamondCenter + pointInbetweenY)]
	var validCorner : Array = [0]
	var tempArray : Array
	var areWeGoodToGo : bool = false
	var n2 : int
	var n3 : int
	var iteration : int = 0
	var cornerColor: int = 0
	var n4
	var w : int
	var x : int
	var y : int
	var z : int
	var AA : int
	var A : int
	var B : int
	var C : int
	var D : int
	var randomArray : Array = [-1, 0, 0, 1] #swap out for some form of smoothing or easing function
	
	for each in cornerArray:
		cellGridIndex[each][2] = 1
		cellGridIndex[each][3] = int(randi_range(0, 9))
		cornerColor += cellGridIndex[each][3]
	#variation = varianceRate / varianceDivisible
	
	while areWeGoodToGo == false:
		iteration += 1
		
		for point in validCorner:
			n3 = point
			cornerArray.clear()
			cornerIndexArray.clear()
			diamondSquareArray.clear()
			w = n3
			x = ((numCurrent - 1) + n3)
			y = (((maxCurrent - numCurrent))+ n3)
			z = ((maxCurrent - 1) + n3)
			cornerArray = [w, x, y, z]
			for each in cornerArray:
				if cellGridIndex[each][2] != 1:
						cellGridIndex[each][2] = 1
						cellGridIndex[each][3] = randi_range(0, 9) 
				cornerIndexArray.push_back(each)
			diamondCenter = ((cornerIndexArray[0] + cornerIndexArray[1] + cornerIndexArray[2] + cornerIndexArray[3]) / 4)
			pointInbetweenX = (cornerIndexArray[0] + cornerIndexArray[1]) / 2
			pointInbetweenY = (cornerIndexArray[0] + cornerIndexArray[2]) / 2
			AA = ((cornerIndexArray[0] + cornerIndexArray[1] + cornerIndexArray[2] + cornerIndexArray[3]) / 4)
			A = (cornerIndexArray[0] + cornerIndexArray[1]) / 2
			C = (cornerIndexArray[0] + cornerIndexArray[2]) / 2
			B = (diamondCenter * 2) - pointInbetweenX#((AA * 2) - A)
			D = (diamondCenter + (diamondCenter - pointInbetweenY))#(AA + (AA - B))
			diamondSquareArray = [AA, A, B, C, D]
			for each in diamondSquareArray:
				if cellGridIndex[each][2] != 1:
					cellGridIndex[each][2] = 1
					n4 = randomArray.pick_random()
					match each:
						AA:
							cellGridIndex[each][3] = clamp((((cellGridIndex[w][3]) + (cellGridIndex[x][3]) + (cellGridIndex[y][3]) + (cellGridIndex[z][3])) / 4) + n4, 0, 9)
						A:
							cellGridIndex[each][3] = clamp(((cellGridIndex[w][3] + cellGridIndex[x][3]) / 2) + n4, 0, 9)
						B:
							cellGridIndex[each][3] = clamp(((cellGridIndex[y][3] + cellGridIndex[z][3]) / 2) + n4, 0, 9)
						C:
							cellGridIndex[each][3] = clamp(((cellGridIndex[w][3] + cellGridIndex[y][3]) / 2) + n4, 0, 9)
						D:
							cellGridIndex[each][3] = clamp(((cellGridIndex[x][3] + cellGridIndex[z][3]) / 2) + n4, 0, 9)
			tempArray.push_back(diamondCenter)
			tempArray.push_back((pointInbetweenX))
			tempArray.push_back((pointInbetweenY))
		for cell in cellMax:
			if cellGridIndex[cell][2] == 1:
				n2 += 1
		if n2 == cellMax:
			areWeGoodToGo = true
			print(n4)
			#print(AA, A, B, C, D)
			#print(diamondSquareArray)
			#print(cellGridIndex)
			#print(cornerArray)
			#print(cornerIndexArray)
			#print(diamondSquareArray)
		else:
			areWeGoodToGo = false
			n2 = 0
			for each in tempArray:
				if validCorner.find(each) == -1:
					validCorner.push_back(each)
			validCorner.sort()
			tempArray.clear()
			numCurrent = ((numCurrent + 1) / 2)
			maxCurrent = ((maxCurrent + 1) / 2)
			#if (varianceRate / varianceDivisible) == 1:
				#variation = 1
			'else:
				varianceRate -= 2
			print(varianceRate, "/", varianceDivisible)
			print(variation)'

func _ret_to_go():
	_grid_points()
	diamond_square()
	#_cell_fill_in()
	queue_redraw()

func _on_generate_button_pressed() -> void:
	_ret_to_go()

func _on_display_lines_check_toggled(toggled_on: bool) -> void:
	areLinesActive = toggled_on

func _on_num_select_pressed(id) -> void:
	match(id):
		0:
			cellNum = 3
		1:
			cellNum = 5
		2:
			cellNum = 9
		3:
			cellNum = 17
		4:
			cellNum = 33
		5:
			cellNum = 65
		6:
			cellNum =  129
		7:
			cellNum = 257
	cellMax = cellNum * cellNum
	numSelect.text = str(cellNum)
