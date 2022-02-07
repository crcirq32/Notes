def infinite_sequence():
	num = 0
	while True:
		yield num
		num += 1
		yield "This is a cool step wise generator"

