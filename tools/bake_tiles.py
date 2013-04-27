#!/usr/bin/python
from PIL import Image
from itertools import product
import math, os, sys

# take an image and render "fuzzy tiles" which are rendered in-game

def open_image(path):
	result = Image.open(path)
	return result if result.mode == 'RGBA' else result.convert('RGBA')

def xyrange(x,y): 
	return product(xrange(x), xrange(y))

def modulate(color, u):
	r,g,b,a = color
	u = u*u*u*u
	return (r, g, b, int(u*a))

def bake(path):
	src = open_image(path)
	w,h = src.size
	tw = w>>5
	th = h>>5
	tiles = [ src.crop((32*x, 32*y, 32*x+32, 32*y+32)) for y,x in xyrange(th, tw) ]
	pixels = [ tile.load() for tile in tiles ]
	def tileat(x,y): return tiles[x + y*tw]
	def pixat(x,y): return pixels[x + y*tw]
	dst = Image.new('RGBA', (64*tw, 64*th))
	for i,tile in enumerate(tiles):
		sys.stdout.write('.')
		sys.stdout.flush()
		tx = i % tw
		ty = (i-tx) / tw
		result = Image.new('RGBA', (64, 64))
		result.paste(tile, (16,16))
		r = result.load()

		#NSEW NEIGHBORS

		if tx > 0:
			p = pixat(tx-1, ty)
			for y,x in xyrange(32,16):
				r[x,y+16] = modulate(p[x+16,y], x/16.0)
			
		if tx < tw-1:
			p = pixat(tx+1, ty)
			for y,x in xyrange(32,16):
				r[x+16+32,y+16] = modulate(p[x,y], 1.0-x/16.0)

		if ty > 0:
			p = pixat(tx, ty-1)
			for y,x in xyrange(16,32):
				r[x+16,y] = modulate(p[x,y+16], y/16.0)

		if ty < th-1:
			p = pixat(tx, ty+1)
			for y,x in xyrange(16,32):
				r[x+16,y+16+32] = modulate(p[x,y], 1.0-y/16.0)

		# CORNER NEIGHBORS

		if tx > 0 and tx > 0:
			p = pixat(tx-1, ty-1)
			for y,x in xyrange(16,16):
				r[x,y] = modulate(p[16+x,16+y], (x/16.0)*(y/16.0))

		if tx > 0 and ty < th-1:
			p = pixat(tx-1, ty+1)
			for y,x in xyrange(16,16):
				r[x,y+16+32] = modulate(p[16+x,y], (x/16.0)*(1.0-y/16.0))

		if tx < th-1 and tx > 0:
			p = pixat(tx+1, ty-1)
			for y,x in xyrange(16,16):
				r[x+16+32,y] = modulate(p[x,16+y], (1.0-x/16.0)*(y/16.0))

		if tx < th-1 and ty < th-1:
			p = pixat(tx+1, ty+1)
			for y,x in xyrange(16,16):
				r[x+16+32,y+16+32] = modulate(p[x,y], (1.0-x/16.0)*(1.0-y/16.0))

		dst.paste(result, (64*tx, 64*ty))

	sys.stdout.write('\n')
	d,f = os.path.split(path)
	n,ext = os.path.splitext(f)
	dst.save('images/%s_baked.png' % n)

if __name__ == '__main__':
	for path in sys.argv[1:]:
		bake(path)
