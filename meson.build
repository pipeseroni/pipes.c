project('pipes.c', 'c',
  version : '0.1',
  default_options : ['warning_level=2'])

compiler = meson.get_compiler('c')

conf_data = configuration_data()
conf_data.set('_POSIX_C_SOURCE', '200809L', description : 'Use POSIX 200809L features')

curses_dep = dependency('curses')
iconv_dep = dependency('iconv')
rt_dep = compiler.find_library('rt')
m_dep = compiler.find_library('m')

if compiler.has_function(
    'init_extended_color',
    prefix : '#include <curses.h>',
    dependencies : curses_dep)
  conf_data.set('HAVE_EXTENDED_COLOR', true)
endif

if compiler.has_function(
    'alloc_pair',
    prefix : '#include <curses.h>',
    dependencies : curses_dep)
  conf_data.set('HAVE_ALLOC_PAIR', true)
endif

if compiler.has_function_attribute('format')
  conf_data.set('HAVE_FUNC_ATTRIBUTE_FORMAT', true)
endif

if compiler.has_function_attribute('unused')
  conf_data.set('HAVE_FUNC_ATTRIBUTE_UNUSED', true)
endif

if compiler.check_header('stdnoreturn.h')
  conf_data.set('HAVE_STDNORETURN_H', true)
endif

configure_file(output : 'config.h', configuration : conf_data)

cpipes_exe = executable(
  'cpipes',
  'src/cpipes.c',
  'src/pipe.c',
  'src/render.c',
  'src/util.c',
  'src/err.c',
  'src/pipe_cell_list.c',
  'src/location_buffer.c',
  'src/canvas.c',
  install : true,
  dependencies : [curses_dep, iconv_dep, rt_dep, m_dep]
)
