#!/usr/bin/python

from PIL import Image
from glob import glob

# running these images through PIL removes a lot of the crud from photoshop

def main():
	for path in glob('images/*.png'):
		im = Image.open(path)
		im.save(path)

if __name__ == '__main__':
	main()
