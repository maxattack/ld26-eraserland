#!/usr/bin/python

from PIL import Image, ImageFont, ImageDraw
from bake_tiles import xyrange

def main():
	result = Image.new('RGBA', (832, 512))
	draw = ImageDraw.Draw(result)
	tw = 832/32
	th = 512/32
	font = ImageFont.load_default()
	for y,x in xyrange(th,tw):
		i = (x + y)
		if i%2 == 0:
			color = (0,0,0,255)
		else:
			color = (255,255,255,255)
		draw.rectangle((32*x, 32*y, 32*x+32, 32*y+32), fill=color)
		j = x + tw * y
		if i%2 == 0:
			color = (255,255,255,255)
		else:
			color = (0,0,0,255)
			
		draw.text((32*x+4, 32*y+4), '%d' % j, fill=color)

		draw.text((32*x+1, 32*y+4+12), '%d,%d' % (x,y), fill=(128,128,128,255))
	result.save('idgrid.png')
	#result.show()


if __name__ == '__main__': main()