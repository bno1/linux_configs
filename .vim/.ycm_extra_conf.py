import os

FLAGS = [
	'-Wall',
	'-Wextra',
]

C_EXTENSIONS = [
	'.c',
	'.h'
]

CPP_EXTENSIONS = [
	'.cpp',
	'.cxx',
	'.cc',
	'.hxx',
	'.hpp',
	'.hh'
]

WORKING_DIR = os.path.dirname(os.path.abspath(__file__))

def MakeRelativePathsInFlagsAbsolute(flags, working_dir):
	make_next_absolute = False
	new_flags = []
	path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]

	for flag in flags:
		new_flag = flag

		if make_next_absolute:
			make_next_absolute = False
			if not flag.startswith('/'):
				new_flag = os.path.join(working_dir, flag)
		elif flag in path_flags:
			make_next_absolute = True
		else:
			for path_flag in path_flags:
				if flag.startswith(path_flag):
					dir_part = flag[len(path_flag):]
					new_flag = path_flag + os.path.join(working_dir, dir_part)
					break

		new_flags.append(new_flag)

	return new_flags

def FlagsForFile(filename):
	extension = os.path.splitext(filename)[1]
	flags = MakeRelativePathsInFlagsAbsolute(FLAGS, WORKING_DIR)

	if extension in C_EXTENSIONS:
		flags.append('-xc')
	elif extension in CPP_EXTENSIONS:
		flags.append('-xc++')

	return {
		'flags': flags,
		'do_cache': True
	}
