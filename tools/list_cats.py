from glob import glob
import os, shutil

def main():
	for path in glob('images/cat*.png'):
		d,f = os.path.split(path)
		cat,num,name = f.split('_')
		outPath = os.path.join(d,'%s_%s.png' % (cat,num))
		shutil.move(path, outPath)
		print '\t"%s"' % outPath

if __name__ == '__main__': main()
