#!/usr/bin/python

from PIL import Image
from glob import glob

# running these images through PIL removes a lot of the crud from photoshop

def main():
	for path in glob('images/*.png'):
		print path
		im = Image.open(path)
		result = Image.new('RGBA', im.size)
		result.paste(im, (0,0))
		result.save(path)

if __name__ == '__main__':
	main()
